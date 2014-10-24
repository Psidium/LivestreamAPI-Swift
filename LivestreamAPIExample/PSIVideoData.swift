//PSIVideoData.swift
//Copyright (c) 2014 Gabriel Borges Fernandes
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit

struct PSIVideoData {
    ///Video ID. json tag: id
    var id: Int
    ///Video title. json tag: caption
    var title: String
    ///Full video description. json tag: description
    var description: String
    ///Total video views. json tag: views
    var views: Int
    ///HD stream link (see .stream for SD). json tag: secure_progressive_url_hd
    var streamHD: NSURL?
    ///SD stream link (see .streamHD for HD). json tag: secure_progressive_url
    var stream: NSURL?
    ///duration of the video in milisseconds. json tag: duration
    var duration: Int
    ///Thumbnail small. json tag: thumbnail_url_small
    var smallThumb: NSURL?
    ///Thumbnail normal size. json tag: thumbnail_url
    var thumbnail: NSURL?
    ///Date published at the GMT time. Format: "2014-09-11T18:55:32.617Z". json tag: publish_at
    var date: String
}
