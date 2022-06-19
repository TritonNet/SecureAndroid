package com.tritonnet.secureandroid.poc

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView

class MainActivity : AppCompatActivity()
{
    companion object
    {
        init
        {
            System.loadLibrary("poc")
        }
    }

    external fun getResponse(request: String): String

    private lateinit var btnInvoke: Button
    private lateinit var txtMessage: TextView

    override fun onCreate(savedInstanceState: Bundle?)
    {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btnInvoke = findViewById(R.id.btnInvoke);
        txtMessage = findViewById(R.id.messageText)

        btnInvoke.setOnClickListener {
            txtMessage.setText(getResponse("Kushan"))
        }

    }
}