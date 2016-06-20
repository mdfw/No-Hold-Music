---
layout: post
title:  "Why?"
date:   2016-06-20
---
### Apple Help books - a review

Apple Help is perfect for what it was designed for (or what I think it was designed for - I didn't ask anyone). It appears to be designed around the idea of a central bookcase for all help on the system. If you assume this purpose, it explains the various design decisions, especially the "floating above everything window" solution that some dislike.

Unfortunately, it hasn't kept up with the pace of change. On my old laptop with a spinning drive, I often receive "Help document unavailable" when the help viewer finally loads. Using reload (cmd-R if you were curious) will sometimes load the content. But more importantly, is having a system-wide help system useful for individual app developers? Is it important that your customer have "access" to the rest of the help books on the system when they load yours? The only place it makes sense is for the system level functions. Maybe being able to call help on system preferences from your application's help has utility, but

1. You need to realize that this is a possibility and use that link.
2. You have to trust that Apple isn't going to change the link.

### Goals of No Hold Music?
**Primary goal:** Provide a spiritual successor to NSHelpManager. It was planned to be API compatible, but since we're already into it as I write this, I can tell you it won't be. It will be "API inspired," but the to improve the flow, we've removed and modified some of the API's. For now, the system will provide a help window to show content. Out of the box, developers should be able to use existing help books with some minor modifications.

**Secondary goals:**
1. Provide a similar system for iOS apps.
2. Provide a tooltip type system, probably without the actual tooltip visual implementation.
