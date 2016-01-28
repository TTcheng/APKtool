package per.pqy.apktool;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.app.Activity;
import java.io.File;
import org.qtproject.qt5.android.bindings.QtActivity;

public class Extra //extends org.qtproject.qt5.android.bindings.QtActivity
{
	public Extra(){}
        public static void installApk(QtActivity activity, String apkFile)
	{
		Intent intent = new Intent(Intent.ACTION_VIEW);  
		final Uri apkuri = Uri.fromFile(new File(apkFile));  
		intent.setDataAndType(apkuri, "application/vnd.android.package-archive");  
                activity.startActivity(intent);
	}

        public static void openFile(QtActivity activity, String file){
                Intent intent = new Intent(Intent.ACTION_VIEW);
                final Uri fileuri = Uri.fromFile(new File(file));
                intent.setDataAndType(fileuri, "*/*");
                activity.startActivity(intent);
            }

}
