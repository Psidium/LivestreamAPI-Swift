//  PSILivestreamAPI.swift
//
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

class PSILivestreamAPI {
    ///store total number of videos
    private var totalVideos = Int.max
    ///Current Event (avoid writing to it)
    private var event: String
    ///Current channel (avoid writing to it)
    private var channel: String
    
    private var completionClosure: () -> ()
    
    var hasLoaded: Bool {
        get {
            return feeds.count >= 10
        }
    }
    ///Useful video data
    var feeds: [PSIVideoData] = [PSIVideoData]() {
        didSet(oldValue) {
            //protect the feed to only have useful data
            if self.totalVideos < feeds.count {
                feeds = oldValue
                println("ERROR: tried to insert more videos in the videoarray than it should have (should have \(self.totalVideos))")
            }
        }
    }
    ///API Initializer. Only start with user and event
    init(channel: String, event: String) {
        //kinda obvious
        self.event = event
        self.channel = channel
        self.completionClosure = { () -> () in
        }
    }
    
    init(channel: String, event: String, completionClosure: () -> ()) {
        self.event = event
        self.channel = channel
        self.completionClosure = completionClosure
    }
    
    func firstLoad(completionClosure: () -> ()) {
        self.completionClosure = completionClosure
        firstLoad()
    }
    
    func firstLoad() {
        if feeds.isEmpty {
            //mount the call url
            let urlPath = "http://new.livestream.com/api/accounts/\(channel)/events/\(event)/feed.json"
            loadDataToArray(urlPath)
        }
    }
    
    func loadMore10(completionClosure: () -> ()) {
        self.completionClosure = completionClosure
        loadMore10()
    }
    
    func loadMore10() {
        if let lastVideo = self.feeds.last {
            //mount the call url
            let urlMore10 = "http://new.livestream.com/api/accounts/\(channel)/events/\(event)/feed.json?&id=\(lastVideo.id)&newer=-1&type=video"
            loadDataToArray(urlMore10)
        } else {
            println("tem no feeds \(self.feeds.count)")
        }
    }
    
    private func loadDataToArray(urlPath:String) {
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        //GET livestream data
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                // If there is an error in the web request, print it to the console
                println("LIVESTREAM API ERROR: \(error.localizedDescription)")
                //TODO saves to a log
            }
            
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if err != nil {
                // If there is an error parsing JSON, print it to the console
                println("Livestream API JSON Error \(err!.localizedDescription)")
                
                //TODO save to a log
            }
            //Pass the raw JSON data to the custom handler
            let json = JSON(jsonResult)
            //Stores the maximum videos of the event for protection
            if let totalCount = json["total"].int {
                self.totalVideos = totalCount
                println("found \(totalCount) videos on event \(self.event) of channel \(self.channel)")
            }  else {
                println(json["total"].error)
            }
            //Read all the data and store
            if let arrayOfData = json["data"].array {
                for (index, singleData) in enumerate(arrayOfData) {
                    //verify wheter this is a video
                    if let isVideo = singleData["type"].string {
                        //If it isn't
                        if isVideo != "video" {
                            //Jump to the next for loop
                            continue
                        }
                    }
                    let currentData = singleData["data"]
                    //As from here you can save the data
                    
                    //Example: Save the needed data
                    let currentVideo = PSIVideoData(
                        id: currentData["id"].intValue,
                        title: currentData["caption"].stringValue,
                        description: currentData["description"].stringValue,
                        views: currentData["views"].intValue,
                        streamHD: currentData["progressive_url_hd"].URL,
                        stream: currentData["progressive_url"].URL,
                        duration: currentData["duration"].intValue,
                        smallThumb: currentData["thumbnail_url_small"].URL,
                        thumbnail: currentData["thumbnail_url"].URL,
                        date: currentData["publish_at"].stringValue
                    )
                    //Definitly save the data
                    self.feeds.append(currentVideo)

                    //DEBUG ONLY
                    println(
                        "----------------START OF \(index)---------------\r" +
                        "id: \(currentVideo.id)\rtitle: \(currentVideo.title)\rdescription: \(currentVideo.description)\rviews\(currentVideo.views)\rstreamhd \(currentVideo.streamHD)\rstram \(currentVideo.stream)\rduration \(currentVideo.duration)\r smallthumb \(currentVideo.smallThumb)\rthumbnail \(currentVideo.thumbnail)\rdate \(currentVideo.date)\r" +
                        "----------------END OF \(index)------------------\r"
                    )
                }
            }
            self.completionClosure()
        })
        task.resume()
    }
    
    
    
}
