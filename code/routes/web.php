<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return redirect('/docs');
});

Route::get('/docs', function () {
    return response()->file(public_path('docs.html'));
});

Route::get('/tests', function () {
    return response()->file(public_path('tests.html'));
});
