package com.roo.feature.service;

import java.util.Date;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.stereotype.Service;

@Service
public class EmailNotificationService {

    public void sendInterviewNotification(String to, String stage, Date scheduleDateTime) {
        String host = System.getProperty("mail.smtp.host");
        String from = System.getProperty("mail.from", "noreply@faculty-recruitment.local");

        if (host == null || host.trim().isEmpty()) {
            return;
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", host);
            Session session = Session.getInstance(props);

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject("Faculty Recruitment Update: " + stage);
            message.setText("Your application moved to stage: " + stage + " on " + scheduleDateTime + ".");
            Transport.send(message);
        } catch (Exception ignored) {
            // Email should not block recruiter workflow.
        }
    }
}
