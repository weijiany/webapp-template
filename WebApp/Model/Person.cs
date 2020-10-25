using System;
using FluentNHibernate.Mapping;

namespace WebApp.Model
{
    public class Person
    {
        public virtual Guid Id { get; set; }
        public virtual string Name { get; set; }
    }

    public class PersonMap : ClassMap<Person>
    {
        public PersonMap()
        {
            Id(x => x.Id);
            Map(x => x.Name);
        }
    }
}