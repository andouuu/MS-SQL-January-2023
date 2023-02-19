use Boardgames
---INSERT---
insert into Boardgames([Name],YearPublished,Rating,CategoryId,PublisherId,PlayersRangeId)
values 
('Deep Blue',2019,5.67,1,15,7),
('Paris',2016,9.78,7,1,5),
('Catan: Starfarers',2021,9.87,7,13,6),
('Bleeding Kansas',2020,3.25,3,7,4),
('One Small Step',2019,5.75,5,9,2)

insert into Publishers([Name],AddressId,Website,Phone)
values
('Agman Games',5,'www.agmangames.com','+16546135542'),
('Amethyst Games',7,'www.amethystgames.com','+15558889992'),
('BattleBooks',13,'www.battlebooks.com','+12345678907')
---UPDATE---
update PlayersRanges
set PlayersMax=PlayersMax+1
where PlayersMin=2 and PlayersMax=2
update Boardgames
set [Name]=concat([Name],'V2')
where YearPublished>=2020
---DELETE---
delete CreatorsBoardgames
from CreatorsBoardgames cbg
inner join Boardgames bg
on bg.Id=cbg.BoardgameId
inner join Publishers p
on p.Id=bg.PublisherId
inner join Addresses a
on a.Id=p.AddressId
where a.Town like 'L%'
delete Boardgames
from Boardgames bg
inner join Publishers p
on p.Id=bg.PublisherId
inner join Addresses a
on a.Id=p.AddressId
where a.Town like 'L%'
delete Publishers
from Publishers p
inner join Addresses a
on a.Id=p.AddressId
where a.Town like 'L%'
delete from Addresses
where Town like 'L%'

---05---
use Boardgames
select [Name],Rating
from Boardgames
order by YearPublished asc,[Name] desc
-------
select bg.Id,bg.[Name],bg.YearPublished,c.[Name]
from Boardgames bg
inner join Categories c
on c.Id=bg.CategoryId
where c.[Name]='Wargames' or c.[Name]='Strategy Games'
order by YearPublished desc
--------
select c.Id,CONCAT(c.FirstName,' '+c.LastName) as CreatorName,c.Email
from Creators c
left join CreatorsBoardgames cbg
on cbg.CreatorId=c.Id
where cbg.BoardgameId is null
--------
select top 5 bg.[Name],Rating,c.[Name]
from Boardgames bg
inner join Categories c
on c.Id=bg.CategoryId
inner join PlayersRanges pr
on pr.Id=bg.PlayersRangeId
where (Rating>7 and bg.[Name] like '%A%')or(rating>7.5 and pr.PlayersMin=2 and pr.PlayersMax=5 )
order by bg.[Name] asc,bg.Rating desc
--------
select concat(c.FirstName,' '+c.LastName) as FullName,c.Email,max(bg.Rating)
from Creators c
inner join CreatorsBoardgames cbg
on cbg.CreatorId=c.Id
inner join Boardgames bg
on bg.Id=cbg.BoardgameId
where c.Email like '%.com'
group by concat(c.FirstName,' '+c.LastName),c.Email
order by FullName asc
--------
select c.LastName,ceiling(avg(bg.Rating)) as AverageRating,p.[Name]
from Creators c
inner join CreatorsBoardgames cbg
on cbg.CreatorId=c.Id
inner join Boardgames bg
on bg.Id=cbg.BoardgameId
inner join Publishers p
on p.Id=bg.PublisherId
where p.[Name]='Stonemaier Games'
group by c.LastName,p.[Name]
order by avg(bg.Rating) desc
--------
go
create function udf_CreatorWithBoardgames(@name nvarchar(30))
returns int
begin
return (select count(cbg.BoardgameId)
from Creators c
inner join CreatorsBoardgames cbg
on cbg.CreatorId=c.Id
where c.FirstName=@name)
end
-------
go
create procedure [usp_SearchByCategory] (@category varchar(50))
as
begin
select bg.[Name]
,bg.YearPublished
,bg.Rating
,c.[Name] as CategoryName
,p.[Name] as PublisherName
,concat(pr.PlayersMin,' people') as MinPlayers
,concat(pr.PlayersMax,' people') as MaxPlayers
from Boardgames bg
inner join PlayersRanges pr
on pr.Id=bg.PlayersRangeId
inner join Categories c
on c.Id=bg.CategoryId
inner join Publishers p
on p.Id=bg.PublisherId
where c.[Name]=@category
order by p.[Name] asc,bg.YearPublished desc
end
go
EXEC usp_SearchByCategory 'Wargames' 