<?php

$curl = curl_init();

curl_setopt_array($curl, array(
  CURLOPT_URL => "https://people.cs.clemson.edu/~jacksod/api/v1/involvements",
  CURLOPT_RETURNTRANSFER => true,
  CURLOPT_ENCODING => "",
  CURLOPT_MAXREDIRS => 10,
  CURLOPT_TIMEOUT => 30,
  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
  CURLOPT_CUSTOMREQUEST => "GET",
  CURLOPT_POSTFIELDS => "-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"test\"\r\n\r\nvalue\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"test2\"\r\n\r\nvalue2\r\n-----011000010111000001101001--",
  CURLOPT_HTTPHEADER => array(
    "cache-control: no-cache",
    "content-type: multipart/form-data; boundary=---011000010111000001101001",
    "postman-token: a5f16c61-1ee5-c520-cd88-b557a7dda70f"
  ),
));

$response = curl_exec($curl);
$err = curl_error($curl);

curl_close($curl);

if ($err) {
  echo "cURL Error #:" . $err;
} else {
  echo $response;
}