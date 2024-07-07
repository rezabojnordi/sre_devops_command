data "http" "ip" {
  url = "https://ifconfig.me"
}

output "ip" {
  value = data.http.ip.body
}
