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

        [TestCleanup]
        public void TearDown()
        {
            driver.Quit();
        }
    }
}
