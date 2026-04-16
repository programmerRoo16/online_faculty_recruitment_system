package com.roo.feature.dto;

public class PublicationInput {
    private int journalsScopus;
    private int journalsUgc;
    private int books;
    private int conferences;
    private int patents;

    public int getJournalsScopus() {
        return journalsScopus;
    }

    public void setJournalsScopus(int journalsScopus) {
        this.journalsScopus = journalsScopus;
    }

    public int getJournalsUgc() {
        return journalsUgc;
    }

    public void setJournalsUgc(int journalsUgc) {
        this.journalsUgc = journalsUgc;
    }

    public int getBooks() {
        return books;
    }

    public void setBooks(int books) {
        this.books = books;
    }

    public int getConferences() {
        return conferences;
    }

    public void setConferences(int conferences) {
        this.conferences = conferences;
    }

    public int getPatents() {
        return patents;
    }

    public void setPatents(int patents) {
        this.patents = patents;
    }
}
