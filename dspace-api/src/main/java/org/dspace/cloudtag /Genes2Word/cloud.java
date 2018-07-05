package org.dspace.cloudtag.Genes2Word;

import java.util.*;
import java.io.*;
import org.dspace.cloudtag.Genes2Word.Stemming.*;
import org.dspace.cloudtag.Genes2Word.Sorting.*;
import org.dspace.cloudtag.Genes2Word.StopWordRemoval.*;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import java.awt.*;
import javax.swing.SwingUtilities;

public class cloud
{
        String WORDS[];
        int FREQ[];
        int temp,len=0;
	public void main(String args[])throws IOException
	{
		int i,j;
		//BufferedReader br1=new BufferedReader(new InputStreamReader(System.in));
		//System.out.println("Enter the path of directory: ");
		//String path=br1.readLine();
                String path=args[0];
		RemoveStopWord.copy_stop_words_mem(path+"/../StopWords.Stemmed");
		File f1=new File(path);
                File directory=new File(path);
		int fileCount=directory.list().length;
		String s[]=f1.list();
		//System.out.println("Processing first 100 file of dataset. . .\n");
		//System.out.println("Please Wait for few minutes. . .\n");
		int r;
		for(i=0;i<fileCount;i++)
		{
			//System.out.println((i+1)+". File Processed: "+s[i]);
			
			
			Porter ob=new Porter();
			FileInputStream f2=new FileInputStream(path+"/"+s[i]);
			String hash="";
			while((r=f2.read())!=-1)
			{
				char c=(char) r;
				if((c>='A'&&c<='Z')||(c>='a'&&c<='z')||c==' '||c=='\t'||c=='\n')
				{
					if(c==' '||c=='\t'||c=='\n')
					{
						if(hash.length()!=0)
						RemoveStopWord.remove_stop_words(ob.stripAffixes(hash));
						hash="";
					
					}
					else
					{
						hash=hash+Character.toLowerCase(c);
					}
					
				}
			}
			if(hash.length()!=0)
			RemoveStopWord.remove_stop_words(ob.stripAffixes(hash));
			RemoveStopWord.RemoveStopWord_main(path+"/../Dictionary");
		}
		Sort obj=new Sort();
		obj.Sort_main(path);
	//	TestOpenCloud.Cloud_main(path);
	//}
//}

//class TestOpenCloud {
	//static String path;
   // protected void initU() {
	File f=new File(path+"/../Top100");
	String Str;
	String WORDS[]=new String[100];
	int FREQ[]=new int[100];
	String shuffle[]=new String[100];
	ArrayList<String> shuffling = new ArrayList<String>();
	int count=0,temp=1000000;
	try{
	Scanner br=new Scanner(f);
	
	while (br.hasNextLine()) 
			{
				Str=br.nextLine();
                                if(!Str.equals("null"))
                                {
                                    len++;    
                                    shuffling.add(Str);
                                 }
			}
		br.close();
	}catch (FileNotFoundException e) {
            e.printStackTrace();
        }
		Collections.shuffle(shuffling);
		for(String str : shuffling)
		{
			
			WORDS[count]=str.substring(0,str.indexOf(' '));
				FREQ[count]=Integer.parseInt(str.substring(str.indexOf(' ')+1,str.length()));
				if(FREQ[count]<temp)
					temp=FREQ[count];
				count++;
		}	
     /*   JFrame frame = new JFrame(TestOpenCloud.class.getSimpleName());
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JPanel panel = new JPanel();
        //Cloud cloud = new Cloud();
        Random random = new Random();
        for (i=0;i<100;i++) {
            
       
			final int red = (int) (Math.random() * 150);
			final int green = (int) (Math.random() * 150);
			final int blue = (int) (Math.random() * 150);
            final JLabel label = new JLabel(WORDS[i]);
            label.setOpaque(false);
            label.setFont(new Font("Andalus", Font.PLAIN, ((FREQ[i]*10)/temp)));
			Color color=new Color(red,green,blue);
			label.setForeground(color);
            panel.add(label);
        }
        frame.add(panel);
        frame.setSize(1366, 768);
        frame.setVisible(true);*/
	//for (i = 0;i < 100;i++)
	//	System.out.println(WORDS[i]+"-->"+FREQ[i]);
        //return (WORDS);
        this.WORDS=WORDS;
        this.FREQ=FREQ;
        this.temp = temp;
    }

 //   public static void Cloud_main(String Path) {
//	path=Path;
     //   SwingUtilities.invokeLater(new Runnable() {
      //      @Override
      //      public void run() {
       //         new TestOpenCloud().initU();
         //   }
     //   }
        public String[] getWORDS()
        {
            return WORDS;
        }
        public int[] getFREQ()
        {
            return FREQ;
        }
        public int getTemp()
        {
            return temp;
        }
        
}
		
