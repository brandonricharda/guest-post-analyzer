# README

**Deployed Version:**
https://serene-dusk-25063.herokuapp.com/

## Application Summary

Given a list of Google Doc links, this application will extract hyperlinks and anchor texts from them. It will then show the user each anchor text and its associated hyperlink on the next screen.

The intended use case for this application is streamlining the guest post review process. Rather than having to open each document and check the links, you can simply place their Google Doc URLs in this tool and it will extract them all for you in a matter of seconds.

I'll also be adding more features (i.e. plagiarism and grammar checks) to streamline the article review process further.

## Technical Information

I built this application using the following technologies.

**Back-End:**
- Rails 6.1.3.2
- Ruby 3.0.1
- PostgreSQL
- RSpec (for testing)
- Google Drive API

**Front-End:**
- Bulma

## How to Use This Application

Here's a guide to using this application (including some of the errors you may run into if you input things incorrectly).

### Step 1: Open the Application

Visit this URL to access the application:

https://serene-dusk-25063.herokuapp.com/

**Note:** This app is hosted on Heroku using a free plan. If it hasn't been used in a while, the server will take some time to load. Just let it sit for a few seconds.

### Step 2: Enter Your Google Doc URLs on the Homepage

<img src="https://github.com/brandonricharda/guest-post-analyzer/blob/main/app/assets/images/guest-post-analyzer-new-batch-page.png">

Next, you'll arrive at a screen that looks like this. Enter your Google Doc share URLs in the text area. Make sure to:
1. Place one URL per line.
2. Link only to files that are native Google Docs. If you feed the application .docx files, it will skip those files and show you an error where the results otherwise would've been (I'll show you what I mean in a second).
3. Link only to files that have permissions "Anyone with this link can edit." The tool accesses Google Doc files through a service account. If your permissions are set to something more private, those files will also be skipped.

Once you've entered your Google Doc URLs, hit "Create Batch." The app will pause for a few seconds. During this time, it's working with the Google Drive API to scan your documents and pull the necessary information.

### Step 3: See the Results on the Next Page

<img src="https://github.com/brandonricharda/guest-post-analyzer/blob/main/app/assets/images/guest-post-analyzer-results-page.png">

As of writing, the application extracts all the anchor texts in each article along with their hyperlinks and lists them for you (grouped by article). You can click on the anchor text and it will open in a new tab to show you what link the writer used.

If you entered a .docx URL, that article's associated box will simply contain an error message.

<img src="https://github.com/brandonricharda/guest-post-analyzer/blob/main/app/assets/images/guest-post-analyzer-invalid-file.png">

Click the "View Article on Google Drive" button to see which one it is. Then, return to the Homepage and create a new batch, replacing the faulty URL you initially input with a proper native Google Doc URL.

## What's Happening Behind the Scenes

This app uses a PostgreSQL databse containing two tables:
1. Batches
2. GuestPosts

When you enter your Google Doc URLs on the first screen, you're creating a **Batch.** The **:urls** column of that record will contain a single string with all of the URLs you've entered. A callback in the Batch model then calls the **create_guest_posts** method, which relies on a helper method to split that long string into several URLs and generate **GuestPosts** from them.

Each **GuestPost** model has a column containing the file's Google URL. If you entered an invalid URL (including one with incorrect permissions), the **GuestPost** record will not be created at all. This is to prevent improper files from breaking the application in subsequent steps.

The mechanism that scans each **GuestPost** and extracts its hyperlinks and URLs is a model method. Every single time you reload the results page, it will crawl through the document and grab the data again. This is so you can do things like edit the article and reload the results screen to see updated data rather than having to go back to the first step.
