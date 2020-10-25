namespace WebApp
{
    public class DbConfig
    {
        public string Server { get; set; }
        public string DataBase { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }

        public string ConnectionString()
        {
            return $"Server={Server};Database={DataBase};User Id={UserName};Password={Password};";
        }
    }
}