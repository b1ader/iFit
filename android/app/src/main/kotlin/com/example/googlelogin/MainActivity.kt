package com.example.googlelogin




import androidx.annotation.NonNull
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.FitnessOptions
import com.google.android.gms.fitness.data.DataType
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "getBatteryLevel") {
               getBatteryLevel()
            }
            else {
                result.notImplemented()
            }
        }

    }
    private fun getBatteryLevel() {
        val fitnessOptions = FitnessOptions.builder().addDataType(DataType.TYPE_STEP_COUNT_DELTA).build()
        val fitnessOptions2 = FitnessOptions.builder().addDataType(DataType.TYPE_HEART_RATE_BPM).build()


        Fitness.getRecordingClient(this, GoogleSignIn.getAccountForExtension(this,fitnessOptions ))
            // This example shows subscribing to a DataType, across all possible data
            // sources. Alternatively, a specific DataSource can be used.
            .subscribe(DataType.TYPE_STEP_COUNT_DELTA)
            .addOnSuccessListener {

                Log.i( TAG,"Successfully subscribed!")
            }
            .addOnFailureListener {
                    e ->
                Log.w(TAG, "There was a problem subscribing.", e)


            }

        Fitness.getRecordingClient(this, GoogleSignIn.getAccountForExtension(this,fitnessOptions2 ))
            // This example shows subscribing to a DataType, across all possible data
            // sources. Alternatively, a specific DataSource can be used.
            .subscribe(DataType.TYPE_HEART_RATE_BPM)
            .addOnSuccessListener {

                Log.i( TAG,"Successfully subscribed!")
            }
            .addOnFailureListener {
                    e ->
                Log.w(TAG, "There was a problem subscribing.", e)


            }



    }


        val Any.TAG: String
        get() {
            val tag = javaClass.simpleName
            return if (tag.length <= 23) tag else tag.substring(0, 23)
        }

}

