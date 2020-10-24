using FluentMigrator;

namespace Migration.Migrations
{
    [Migration(202019220902)]
    public class CreatePersonTable : FluentMigrator.Migration
    {
        public override void Up()
        {
            Create.Table("Person")
                .WithColumn("Id").AsGuid().PrimaryKey()
                .WithColumn("Name").AsString();

            Insert.IntoTable("Person")
                .Row(new
                {
                    Id = "A322D6D8-1402-11EB-A094-ACDE48001122",
                    Name = "Lucy"
                });
        }

        public override void Down()
        {
        }
    }
}