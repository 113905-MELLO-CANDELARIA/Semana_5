create database prueba
use prueba
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Asignaturas](
	[id_asignatura] [int] IDENTITY(1,1) NOT NULL,
	[asignatura] [varchar](60) NULL,
 CONSTRAINT [pk_asignatura] PRIMARY KEY CLUSTERED 
(
	[id_asignatura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Carreras]    Script Date: 29/8/2022 20:11:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Carreras](
	[id_carrera] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](60) NULL,
 CONSTRAINT [pk_carrera] PRIMARY KEY CLUSTERED 
(
	[id_carrera] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
alter table Carreras drop column titulo
alter table Carreras add activo bit
/****** Object:  Table [dbo].[DetalleCarreras]    Script Date: 29/8/2022 20:11:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleCarreras](
	[id_carrera] [int] NOT NULL,
	[anioCursado] [int] NULL,
	[cuatrimestre] [int] NULL,
	[id_asignatura] [int] NULL,
	[id_detalle] [int] NOT NULL,
 CONSTRAINT [pk_detalle] PRIMARY KEY CLUSTERED 
(
	[id_detalle] ASC,
	[id_carrera] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DetalleCarreras]  WITH CHECK ADD  CONSTRAINT [fk_asignatura] FOREIGN KEY([id_asignatura])
REFERENCES [dbo].[Asignaturas] ([id_asignatura])
GO
ALTER TABLE [dbo].[DetalleCarreras] CHECK CONSTRAINT [fk_asignatura]
GO
/****** Object:  StoredProcedure [dbo].[pa_ver_asignaturas]    Script Date: 29/8/2022 20:11:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pa_ver_asignaturas]
as
select * from Asignaturas
GO
/****** Object:  StoredProcedure [dbo].[SP_BORRAR_CARRERA]    Script Date: 29/8/2022 20:11:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_BORRAR_CARRERA]
@id_carrera int
as
delete from DetalleCarreras where id_carrera=@id_carrera

delete from Carreras where id_carrera=@id_carrera
GO
/****** Object:  StoredProcedure [dbo].[SP_CANTIDAD_CARRERAS]    Script Date: 29/8/2022 20:11:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_CANTIDAD_CARRERAS]
@cant int output as

set @cant = (select count(id_carrera) from Carreras)
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTAR_DETALLE]    Script Date: 29/8/2022 20:11:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERTAR_DETALLE] 
	@id_carrera int,
	@anioCursado int, 
	@cuatrimestre int, 
	@id_asignatura int,
	@id_detalle int
AS
BEGIN
	INSERT INTO DetalleCarreras(id_detalle,id_Carrera,anioCursado, cuatrimestre, id_asignatura)
    VALUES (@id_Detalle,@id_carrera, @anioCursado, @cuatrimestre, @id_asignatura);
  
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTAR_MAESTRO]    Script Date: 29/8/2022 20:11:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERTAR_MAESTRO] 
	@nombre varchar(60),
	@id_carrera int OUTPUT
AS
BEGIN
	INSERT INTO Carreras(nombre,activo)
    VALUES (@nombre,1);
    --Asignamos el valor del último ID autogenerado (obtenido --  
    --mediante la función SCOPE_IDENTITY() de SQLServer)	
    SET @id_carrera = SCOPE_IDENTITY();

END
GO

/****** Object:  StoredProcedure [dbo].[SP_VER_CARRERAS]    Script Date: 29/8/2022 20:11:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_VER_CARRERAS]
as
Select * from carreras c 
GO
/****** Object:  StoredProcedure [dbo].[SP_VER_DETALLES]    Script Date: 29/8/2022 20:11:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_VER_DETALLES]
@idCarrera int 
as
select d.id_carrera,id_detalle,anioCursado,cuatrimestre,d.id_asignatura,a.asignatura 
from DetalleCarreras d join Asignaturas a on d.id_asignatura=a.id_asignatura

where id_carrera=@idCarrera
GO
exec [SP_VER_DETALLES] 6

CREATE PROCEDURE [SPBaja_Carrera]
@id_carrera bigint
as begin
update Carreras set activo=0
where id_carrera=@id_carrera
end

INSERT INTO Asignaturas VALUES('Inglés I')
INSERT INTO Asignaturas VALUES('SPD')
INSERT INTO Asignaturas VALUES('Matemática')
INSERT INTO Asignaturas VALUES('Programación I')
INSERT INTO Asignaturas VALUES('Laboratorio de Computación I')
INSERT INTO Asignaturas VALUES('Programación II')
INSERT INTO Asignaturas VALUES('Inglés II')
INSERT INTO Asignaturas VALUES('Fisica I')
INSERT INTO Asignaturas VALUES('Fisica II')


select * from carreras
select * from DetalleCarreras WHERE id_carrera=9
delete from Carreras where id_carrera=4

create procedure SP_MODIFICAR_DETALLES
@id_carrera int,
	@anioCursado int, 
	@cuatrimestre int, 
	@id_asignatura int
AS
BEGIN
	update DetalleCarreras set
	anioCursado=@anioCursado,
	cuatrimestre=@cuatrimestre,
	id_asignatura=id_asignatura
	where id_carrera=@id_carrera
  
END
exec SP_MODIFICAR_DETALLES 9,2021,2,3

create procedure SP_Modificar
@id_carrera int
as begin 
delete from DetalleCarreras where id_carrera=id_carrera
end
exec SP_Modificar 4


create procedure VER_2022
	as begin 
	select * from DetalleCarreras 
	where anioCursado=2022
	end
	exec VER_2022




Data Source=DESKTOP-IDA6V66\SQLEXPRESS;Initial Catalog=prueba;Integrated Security=True