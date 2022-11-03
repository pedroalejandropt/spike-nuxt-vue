locals {
  bucket_static_name           = "spike-vue-web"
  bucket_static_nuxt_name      = "spike-nuxt-web"
  bucket_jsons_files_name      = "spike-vue-jsons"
  mime_types                   = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".ico"  = "image/x-icon"
    ".jpeg" = "image/jpeg"
    ".png"  = "image/png"
    ".svg"  = "image/svg+xml"
    ".map"  = "binary/octet-stream"
    "_nuxt/LICENSES" = "binary/octet-stream"
  }
}