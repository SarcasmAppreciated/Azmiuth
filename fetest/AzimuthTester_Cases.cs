using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using OpenQA.Selenium.Chrome;
// using OpenQA.Selenium.IE;

namespace AzimuthTester
{
    [TestClass]
    public class AzimuthTester_Cases
    {

        IWebDriver driver;

        [TestMethod]
        public void Case001_Login()
        {
            // InternetExplorerOptions options = new InternetExplorerOptions();
            // options.IgnoreZoomLevel = true;
            driver = new ChromeDriver();

            driver.Navigate().GoToUrl("http://sheltered-stream-7018.herokuapp.com/");

            IWebElement testLogin = driver.FindElement(By.ClassName("login_button"));
            testLogin.Click();

            IWebElement enterLogin = driver.FindElement(By.Id("username_or_email"));
            enterLogin.SendKeys("azimuth_user_1");
            enterLogin = driver.FindElement(By.Id("password"));
            enterLogin.SendKeys("whiskey");

            IWebElement testAuthorize = driver.FindElement(By.Id("allow"));
            testAuthorize.Click();

            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(4));

            IWebElement findH2 = driver.FindElement(By.TagName("h2"));
            string doesTitleExist = findH2.Text;

            System.Console.WriteLine(doesTitleExist);
            Assert.AreEqual(doesTitleExist,"Profile");
        }

        [TestMethod]
        public void Case002_Logout()
        {
            driver = new ChromeDriver();

            driver.Navigate().GoToUrl("http://sheltered-stream-7018.herokuapp.com/");

            IWebElement testLogin = driver.FindElement(By.ClassName("login_button"));
            testLogin.Click();

            IWebElement enterLogin = driver.FindElement(By.Id("username_or_email"));
            enterLogin.SendKeys("azimuth_user_1");
            enterLogin = driver.FindElement(By.Id("password"));
            enterLogin.SendKeys("whiskey");

            IWebElement testAuthorize = driver.FindElement(By.Id("allow"));
            testAuthorize.Click();

            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(4));

            //Test Start
            IWebElement testLogout = driver.FindElement(By.ClassName("login_button"));
            testLogout.Click();

            WebDriverWait wait2 = new WebDriverWait(driver, TimeSpan.FromSeconds(4));

            IWebElement findH2 = driver.FindElement(By.TagName("h2"));
            string doesTitleExist = findH2.Text;

            System.Console.WriteLine(doesTitleExist);
            Assert.AreEqual("About Azimuth", doesTitleExist);
        }

        [TestMethod]
        public void Case003_Profile_Table_X()
        {
            driver = new ChromeDriver();

            driver.Navigate().GoToUrl("http://sheltered-stream-7018.herokuapp.com/");
            driver.Manage().Window.Maximize();

            IWebElement testLogin = driver.FindElement(By.ClassName("login_button"));
            testLogin.Click();

            IWebElement enterLogin = driver.FindElement(By.Id("username_or_email"));
            enterLogin.SendKeys("azimuth_user_1");
            enterLogin = driver.FindElement(By.Id("password"));
            enterLogin.SendKeys("whiskey");

            IWebElement testAuthorize = driver.FindElement(By.Id("allow"));
            testAuthorize.Click();
            
            //Test Start
            IWebElement findX = driver.FindElement(By.XPath("//div[contains(@class,'x_box profile')]"));
            driver.FindElement(By.XPath("//div[contains(@class,'x_box profile')]")).Click();
            string isX = findX.Text;

            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            wait.Until(x => !driver.FindElement(By.XPath("//div[contains(@class,'table_box profile')]")).Displayed);

            IWebElement checkHeight = driver.FindElement(By.CssSelector("div.table_box.profile"));
            string stringHeight = checkHeight.GetCssValue("height").Replace("px", "");

            int height;
            bool testHeight = Int32.TryParse(stringHeight, out height);
            
            System.Console.WriteLine(height);
            Assert.AreEqual("+", isX);
            Assert.AreEqual(true, height == 0);
            
        }

        [TestMethod]
        public void Case004_Coordinate_Table_X()
        {
            driver = new ChromeDriver();

            driver.Navigate().GoToUrl("http://sheltered-stream-7018.herokuapp.com/");
            driver.Manage().Window.Maximize();

            IWebElement testLogin = driver.FindElement(By.ClassName("login_button"));
            testLogin.Click();

            IWebElement enterLogin = driver.FindElement(By.Id("username_or_email"));
            enterLogin.SendKeys("azimuth_user_1");
            enterLogin = driver.FindElement(By.Id("password"));
            enterLogin.SendKeys("whiskey");

            IWebElement testAuthorize = driver.FindElement(By.Id("allow"));
            testAuthorize.Click();

            //Test Start
            IWebElement findX = driver.FindElement(By.CssSelector("div.x_box.table"));
            driver.FindElement(By.CssSelector("div.x_box.table")).Click();
            string isX = findX.Text;

            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            wait.Until(x => driver.FindElement(By.XPath("//div[contains(@class,'table_box table')]")).Displayed);

            IWebElement checkHeight = driver.FindElement(By.CssSelector("div.table_box.table"));
            string stringHeight = checkHeight.GetCssValue("height");
            stringHeight = stringHeight.Replace("px", "").Substring(0, stringHeight.IndexOf("."));

            int height;
            bool testHeight = Int32.TryParse(stringHeight, out height);

            System.Console.WriteLine(height);
            Assert.AreEqual("+", isX);
            Assert.AreEqual(true, height > 0);
        }

        [TestMethod]
        public void Case005_Check_User_Link()
        {
            driver = new ChromeDriver();

            driver.Navigate().GoToUrl("http://sheltered-stream-7018.herokuapp.com/");
            driver.Manage().Window.Maximize();

            IWebElement testLogin = driver.FindElement(By.ClassName("login_button"));
            testLogin.Click();

            IWebElement enterLogin = driver.FindElement(By.Id("username_or_email"));
            enterLogin.SendKeys("azimuth_user_1");
            enterLogin = driver.FindElement(By.Id("password"));
            enterLogin.SendKeys("whiskey");

            IWebElement testAuthorize = driver.FindElement(By.Id("allow"));
            testAuthorize.Click();

            //Test Start
            IWebElement clickLink = driver.FindElement(By.XPath("//div[contains(@class,'text_split profile sensitive')]/a[contains(@target,'_new')]"));
            string linkName = clickLink.Text;
            clickLink.Click();

            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(4));
            driver.SwitchTo().Window(driver.WindowHandles[1]);
            string isTab = driver.Title;

            System.Console.WriteLine(linkName);
            System.Console.WriteLine(isTab);
            bool testStrings = false;
            if (isTab.IndexOf(linkName) != -1)
                testStrings = true;

            Assert.AreEqual(true, testStrings);
        }

        [TestMethod]
        public void Case006_Check_Share()
        {
            driver = new ChromeDriver();

            driver.Navigate().GoToUrl("http://sheltered-stream-7018.herokuapp.com/");
            driver.Manage().Window.Maximize();

            IWebElement testLogin = driver.FindElement(By.ClassName("login_button"));
            testLogin.Click();

            IWebElement enterLogin = driver.FindElement(By.Id("username_or_email"));
            enterLogin.SendKeys("azimuth_user_1");
            enterLogin = driver.FindElement(By.Id("password"));
            enterLogin.SendKeys("whiskey");

            IWebElement testAuthorize = driver.FindElement(By.Id("allow"));
            testAuthorize.Click();

            //Test Start
            IWebElement clickShare = driver.FindElement(By.XPath("//div[contains(@class,'text_split profile sensitive')]/a[contains(@href,'/share_my_path')]"));
            string shareLink = clickShare.Text;
            clickShare.Click();

            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));

            IWebElement clickLink = driver.FindElement(By.XPath("//div[contains(@class,'text_split profile sensitive')]/a[contains(@target,'_new')]"));
            clickLink.Click();
            WebDriverWait wait1 = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            driver.SwitchTo().Window(driver.WindowHandles[1]);

            WebDriverWait wait2 = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            wait2.Until(x => driver.FindElement(By.XPath("//a[contains(@href,'/hashtag/AzimuthSailing?src=hash')]")).Displayed);           
            IWebElement findTweet = driver.FindElement(By.XPath("//a[contains(@href,'/hashtag/AzimuthSailing?src=hash')]"));
            string isTweet = findTweet.Text;


            bool testStrings = false;
            if(isTweet.IndexOf("AzimuthSailing") != -1)
                testStrings = true;

            System.Console.WriteLine(shareLink);
            System.Console.WriteLine(isTweet);
            Assert.AreEqual("Share!", shareLink);
            Assert.AreEqual(true, testStrings);

        }

        [TestMethod]
        public void Case007_Check_Share_Bottom_Logged_Out()
        {
            driver = new ChromeDriver();

            driver.Navigate().GoToUrl("http://sheltered-stream-7018.herokuapp.com/");
            driver.Manage().Window.Maximize();

            //Test Start
            IWebElement clickShare = driver.FindElement(By.XPath("//a[contains(@class,'twitter_public')]"));
            clickShare.Click();

            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            driver.SwitchTo().Window(driver.WindowHandles[1]);

            WebDriverWait wait1 = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            wait1.Until(x => driver.FindElement(By.XPath("//h2[contains(@class,'action-information')]")).Displayed);
            IWebElement findText = driver.FindElement(By.XPath("//h2[contains(@class,'action-information')]"));
            string isH2 = findText.Text;

            System.Console.WriteLine(isH2);
            Assert.AreEqual("What’s happening?", isH2);
        }

        [TestMethod]
        public void Case008_Check_Share_Bottom_Logged_In()
        {
            driver = new ChromeDriver();

            driver.Navigate().GoToUrl("http://sheltered-stream-7018.herokuapp.com/");
            driver.Manage().Window.Maximize();

            IWebElement testLogin = driver.FindElement(By.ClassName("login_button"));
            testLogin.Click();

            IWebElement enterLogin = driver.FindElement(By.Id("username_or_email"));
            enterLogin.SendKeys("azimuth_user_1");
            enterLogin = driver.FindElement(By.Id("password"));
            enterLogin.SendKeys("whiskey");

            IWebElement testAuthorize = driver.FindElement(By.Id("allow"));
            testAuthorize.Click();

            //Test Start
            IWebElement clickShare = driver.FindElement(By.XPath("//a[contains(@class,'twitter_public')]"));
            clickShare.Click();
            
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            driver.SwitchTo().Window(driver.WindowHandles[1]);

            WebDriverWait wait1 = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            wait1.Until(x => driver.FindElement(By.XPath("//h2[contains(@class,'action-information')]")).Displayed);
            IWebElement findText = driver.FindElement(By.XPath("//h2[contains(@class,'action-information')]"));
            string isH2 = findText.Text;

            System.Console.WriteLine(isH2);
            Assert.AreEqual("What’s happening?", isH2);
        }


        [TestCleanup]
        public void TearDown()
        {
            driver.Quit();
        }
    }
}
