Create database Boardgames
use Boardgames
create table Categories(
Id int primary key identity,
[Name] varchar(50) not null
)
create table Addresses(
Id int primary key identity,
StreetName nvarchar(100) not null,
StreetNumber int not null,
Town varchar(30) not null,
Country varchar(50) not null,
ZIP int not null
)
create table Publishers(
Id int primary key identity,
[Name] varchar(30) unique not null,
AddressId int foreign key references Addresses(Id) not null,
Website nvarchar(40) null, 
Phone nvarchar(20) null
)
create table PlayersRanges(
Id int primary key identity,
PlayersMin int not null,
PlayersMax int not null
)
create table Boardgames(
Id int primary key identity,
[Name] nvarchar(30) not null,
YearPublished int not null,
Rating decimal(18,2) not null,
CategoryId int foreign key references Categories(Id) not null,
PublisherId int foreign key references Publishers(Id) not null,
PlayersRangeId int foreign key references PlayersRanges(Id) not null
)
create table Creators(
Id int primary key identity,
FirstName nvarchar(30),
LastName nvarchar(30),
Email nvarchar(30)
)
create table CreatorsBoardgames(
CreatorId int foreign key references Creators(Id),
BoardgameId int foreign key references Boardgames(Id),
Primary key(CreatorId,BoardgameId)
)