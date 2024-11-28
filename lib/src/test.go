package main

import (
    "fmt"
    "io"
    "net/http"
    "os"
)

func uploadHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodPost {
        http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
        return
    }

    // Parse the multipart form
    err := r.ParseMultipartForm(10 << 20) // 10 MB
    if err != nil {
        http.Error(w, "Error parsing form", http.StatusInternalServerError)
        return
    }

    // Retrieve the file from form data
    file, handler, err := r.FormFile("file")
    if err != nil {
        http.Error(w, "Error retrieving file", http.StatusInternalServerError)
        return
    }
    defer file.Close()

    // Print file details to console
    fmt.Printf("Uploaded File: %s\n", handler.Filename)
    fmt.Printf("File Size: %d\n", handler.Size)
    fmt.Printf("MIME Header: %v\n", handler.Header)

    // Optionally, save the file to disk
    dst, err := os.Create(handler.Filename)
    if err != nil {
        http.Error(w, "Error saving file", http.StatusInternalServerError)
        return
    }
    defer dst.Close()
    if _, err := io.Copy(dst, file); err != nil {
        http.Error(w, "Error saving file", http.StatusInternalServerError)
        return
    }

    fmt.Fprintf(w, "File uploaded successfully: %s\n", handler.Filename)
}

func main() {
    http.HandleFunc("/upload", uploadHandler)
    fmt.Println("Server started at :8080")
    http.ListenAndServe(":8080", nil)
}