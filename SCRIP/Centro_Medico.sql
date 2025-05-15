USE [master]
GO
-- Crea la base de datos Centro_Medico
CREATE DATABASE [Centro_Medico]
GO

-- Cambia el contexto a la base de datos Centro_Medico
USE [Centro_Medico]
GO

-- Crea tipos de datos definidos por el usuario
CREATE TYPE [dbo].[historia] FROM [int] NOT NULL
GO
CREATE TYPE [dbo].[Medico] FROM [int] NOT NULL
GO
CREATE TYPE [dbo].[observacion] FROM [varchar](1000) NOT NULL
GO
CREATE TYPE [dbo].[Paciente] FROM [int] NOT NULL
GO
CREATE TYPE [dbo].[Turno] FROM [int] NOT NULL
GO

-- Crea la tabla 'concepto'
CREATE TABLE [dbo].[concepto](
	[idconcepto] [tinyint] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](100) NULL,
CONSTRAINT [PK_concepto] PRIMARY KEY CLUSTERED ([idconcepto] ASC)
) ON [PRIMARY]
GO

-- Crea la tabla 'Especialidad'
CREATE TABLE [dbo].[Especialidad](
	[idEspecialidad] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](30) NULL,
CONSTRAINT [PK_Especialidad] PRIMARY KEY CLUSTERED ([idEspecialidad] ASC)
) ON [PRIMARY]
GO

-- Crea la tabla 'historia'
CREATE TABLE [dbo].[historia](
	[idHistoria] [dbo].[historia] IDENTITY(1,1) NOT NULL,
	[fechaHistoria] [datetime] NULL,
	[observacion] [dbo].[observacion] NULL,
CONSTRAINT [PK_historia] PRIMARY KEY CLUSTERED ([idHistoria] ASC)
) ON [PRIMARY]
GO

-- Tabla 'historiapaciente'
-- Clave primaria compuesta: la combinación de idHistoria, idPaciente e idMedico
-- identifica de forma única cada registro, indicando una historia clínica específica
-- para un paciente atendido por un médico en particular.
CREATE TABLE [dbo].[historiapaciente](
	[idHistoria] [dbo].[historia] NOT NULL,
	[idPaciente] [dbo].[Paciente] NOT NULL,
	[idMedico] [dbo].[Medico] NOT NULL,
CONSTRAINT [PK_historiapaciente] PRIMARY KEY CLUSTERED ([idHistoria] ASC, [idPaciente] ASC, [idMedico] ASC)
) ON [PRIMARY]
GO

-- Crea la tabla 'Medico'
CREATE TABLE [dbo].[Medico](
	[idMedico] [dbo].[Medico] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NULL,
	[Apellido] [varchar](50) NULL,
CONSTRAINT [PK__Medico__4E03DEBA23A33804] PRIMARY KEY CLUSTERED ([idMedico] ASC)
) ON [PRIMARY]
GO

-- Tabla 'MedicoEspecialidad'
-- Clave primaria compuesta: la combinación de idMedico e idEspecialidad
-- asegura que cada médico solo esté asociado una vez con cada especialidad.
CREATE TABLE [dbo].[MedicoEspecialidad](
	[idMedico] [dbo].[Medico] NOT NULL,
	[idEspecialidad] [int] NOT NULL,
	[Descripcion] [varchar](50) NULL,
CONSTRAINT [PK__MedicoEs__50896FDAA6F6710D] PRIMARY KEY CLUSTERED ([idMedico] ASC, [idEspecialidad] ASC)
) ON [PRIMARY]
GO

-- Crea la tabla 'paciente'
CREATE TABLE [dbo].[paciente](
	[idPaciente] [dbo].[Paciente] IDENTITY(1,1) NOT NULL,
	[dni] [varchar](20) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[apellido] [varchar](50) NOT NULL,
	[fechanacimiento] [date] NOT NULL,
	[domicilio] [varchar](50) NOT NULL,
	[idPais] [char](3) NULL,
	[telefono] [varchar](20) NULL,
	[email] [varchar](30) NOT NULL,
	[observacion] [dbo].[observacion] NULL,
CONSTRAINT [PK_paciente] PRIMARY KEY CLUSTERED ([idPaciente] ASC)
) ON [PRIMARY]
GO

-- Crea la tabla 'Pago'
CREATE TABLE [dbo].[Pago](
	[idPago] [int] IDENTITY(1,1) NOT NULL,
	[concepto] [tinyint] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[monto] [money] NOT NULL,
	[estado] [tinyint] NULL,
	[obs] [dbo].[observacion] NULL,
CONSTRAINT [PK__Pago__BD2295ADE08E9971] PRIMARY KEY CLUSTERED ([idPago] ASC)
) ON [PRIMARY]
GO

-- Tabla 'PagoPaciente'
-- Clave primaria compuesta: la combinación de IdPago, IdPaciente e IdTurno
-- se hace para poder hacer las restricciones con dicha tabla y para identificar
-- de forma única cada pago realizado por un paciente para un turno específico.
CREATE TABLE [dbo].[PagoPaciente](
	[IdPago] [int] NOT NULL,
	[IdPaciente] [dbo].[Paciente] NOT NULL,
	[IdTurno] [dbo].[Turno] NOT NULL,
CONSTRAINT [PK__PagoPaci__CBD72D84E6645485] PRIMARY KEY CLUSTERED ([IdPago] ASC, [IdPaciente] ASC, [IdTurno] ASC)
) ON [PRIMARY]
GO

-- Crea la tabla 'Pais'
CREATE TABLE [dbo].[Pais](
	[idPais] [char](3) NOT NULL,
	[Pais] [varchar](30) NULL,
CONSTRAINT [PK_Pais] PRIMARY KEY CLUSTERED ([idPais] ASC)
) ON [PRIMARY]
GO

-- Crea la tabla 'turno'
CREATE TABLE [dbo].[turno](
	[idTurno] [dbo].[Turno] IDENTITY(1,1) NOT NULL,
	[fechaturno] [datetime] NULL,
	[estado] [smallint] NULL,
	[observacion] [dbo].[observacion] NULL,
CONSTRAINT [PK_turno] PRIMARY KEY CLUSTERED ([idTurno] ASC)
) ON [PRIMARY]
GO

-- Crea la tabla 'turno/estado'
CREATE TABLE [dbo].[turno/estado](
	[idEstado] [smallint] NOT NULL,
	[Descripcion] [varchar](50) NULL,
CONSTRAINT [PK_turno/estado] PRIMARY KEY CLUSTERED ([idEstado] ASC)
) ON [PRIMARY]
GO

-- Tabla 'turnopaciente'
-- Clave primaria compuesta: la combinación de idTurno, idPaciente e idMedico
-- se utiliza para poder hacer las restricciones con dicha tabla y para identificar
-- de forma única la asignación de un paciente a un turno con un médico específico.
CREATE TABLE [dbo].[turnopaciente](
	[idTurno] [dbo].[Turno] NOT NULL,
	[idPaciente] [dbo].[Paciente] NOT NULL,
	[idMedico] [dbo].[Medico] NOT NULL,
CONSTRAINT [PK_turnopaciente] PRIMARY KEY CLUSTERED ([idTurno] ASC, [idPaciente] ASC, [idMedico] ASC)
) ON [PRIMARY]
GO

-- Define las relaciones de clave externa
ALTER TABLE [dbo].[historiapaciente] WITH CHECK ADD CONSTRAINT [FK_historiapaciente_historia] FOREIGN KEY([idHistoria])
REFERENCES [dbo].[historia] ([idHistoria])
GO
-- FK_historiapaciente_historia: Vincula cada registro de la tabla historiapaciente con una historia clínica específica en la tabla historia.
ALTER TABLE [dbo].[historiapaciente] CHECK CONSTRAINT [FK_historiapaciente_historia]
GO
ALTER TABLE [dbo].[historiapaciente] WITH CHECK ADD CONSTRAINT [FK_historiapaciente_Medico] FOREIGN KEY([idMedico])
REFERENCES [dbo].[Medico] ([idMedico])
GO
-- FK_historiapaciente_Medico: Asegura que cada historia clínica en historiapaciente esté asociada a un médico registrado en la tabla Medico.
ALTER TABLE [dbo].[historiapaciente] CHECK CONSTRAINT [FK_historiapaciente_Medico]
GO
ALTER TABLE [dbo].[historiapaciente] WITH CHECK ADD CONSTRAINT [FK_historiapaciente_paciente] FOREIGN KEY([idPaciente])
REFERENCES [dbo].[paciente] ([idPaciente])
GO
-- FK_historiapaciente_paciente: Asegura que cada historia clínica en historiapaciente pertenezca a un paciente registrado en la tabla paciente.
ALTER TABLE [dbo].[historiapaciente] CHECK CONSTRAINT [FK_historiapaciente_paciente]
GO

ALTER TABLE [dbo].[MedicoEspecialidad] WITH CHECK ADD CONSTRAINT [FK_MedicoEspecialidad_Especialidad] FOREIGN KEY([idEspecialidad])
REFERENCES [dbo].[Especialidad] ([idEspecialidad])
GO
-- FK_MedicoEspecialidad_Especialidad: Permite vincular a cada médico con una o varias especialidades médicas registradas en la tabla Especialidad.
ALTER TABLE [dbo].[MedicoEspecialidad] CHECK CONSTRAINT [FK_MedicoEspecialidad_Especialidad]
GO
ALTER TABLE [dbo].[MedicoEspecialidad] WITH CHECK ADD CONSTRAINT [FK_MedicoEspecialidad_Medico] FOREIGN KEY([idMedico])
REFERENCES [dbo].[Medico] ([idMedico])
GO
-- FK_MedicoEspecialidad_Medico: Permite vincular a cada especialidad médica con uno o varios médicos registrados en la tabla Medico.
ALTER TABLE [dbo].[MedicoEspecialidad] CHECK CONSTRAINT [FK_MedicoEspecialidad_Medico]
GO

ALTER TABLE [dbo].[paciente] WITH CHECK ADD CONSTRAINT [FK_paciente_Pais] FOREIGN KEY([idPais])
REFERENCES [dbo].[Pais] ([idPais])
GO
-- FK_paciente_Pais: Permite registrar el país de origen de cada paciente, referenciando los códigos de país en la tabla Pais.
ALTER TABLE [dbo].[paciente] CHECK CONSTRAINT [FK_paciente_Pais]
GO

ALTER TABLE [dbo].[Pago] WITH CHECK ADD CONSTRAINT [FK_Pago_concepto] FOREIGN KEY([concepto])
REFERENCES [dbo].[concepto] ([idconcepto])
GO
-- FK_Pago_concepto: Vincula cada registro de pago con una descripción del concepto del pago registrada en la tabla concepto.
ALTER TABLE [dbo].[Pago] CHECK CONSTRAINT [FK_Pago_concepto]
GO

ALTER TABLE [dbo].[PagoPaciente] WITH CHECK ADD CONSTRAINT [FK_PagoPaciente_paciente] FOREIGN KEY([IdPaciente])
REFERENCES [dbo].[paciente] ([idPaciente])
Go
-- FK_PagoPaciente_paciente: Vincula cada registro de pago en PagoPaciente con el paciente que realizó el pago en la tabla paciente.
ALTER TABLE [dbo].[PagoPaciente] CHECK CONSTRAINT [FK_PagoPaciente_paciente]
GO
ALTER TABLE [dbo].[PagoPaciente] WITH CHECK ADD CONSTRAINT [FK_PagoPaciente_Pago] FOREIGN KEY([IdPago])
REFERENCES [dbo].[Pago] ([idPago])
GO
-- FK_PagoPaciente_Pago: Vincula cada registro en PagoPaciente con la información detallada del pago en la tabla Pago.
ALTER TABLE [dbo].[PagoPaciente] CHECK CONSTRAINT [FK_PagoPaciente_Pago]
GO
ALTER TABLE [dbo].[PagoPaciente] WITH CHECK ADD CONSTRAINT [FK_PagoPaciente_turno] FOREIGN KEY([IdTurno])
REFERENCES [dbo].[turno] ([idTurno])
GO
-- FK_PagoPaciente_turno: Vincula cada registro de pago en PagoPaciente con el turno al que corresponde el pago en la tabla turno.
ALTER TABLE [dbo].[PagoPaciente] CHECK CONSTRAINT [FK_PagoPaciente_turno]
GO

ALTER TABLE [dbo].[turno] WITH CHECK ADD CONSTRAINT [FK_turno_TurnoEstado] FOREIGN KEY([estado])
REFERENCES [dbo].[turno/estado] ([idEstado])
GO
-- FK_turno_TurnoEstado: Vincula cada turno con su estado correspondiente definido en la tabla turno/estado.
ALTER TABLE [dbo].[turno] CHECK CONSTRAINT [FK_turno_TurnoEstado]
GO

ALTER TABLE [dbo].[turnopaciente] WITH CHECK ADD CONSTRAINT [FK_turnopaciente_Medico] FOREIGN KEY([idMedico])
REFERENCES [dbo].[Medico] ([idMedico])
GO
-- FK_turnopaciente_Medico: Vincula cada asignación de turno en turnopaciente con el médico que atenderá el turno en la tabla Medico.
ALTER TABLE [dbo].[turnopaciente] CHECK CONSTRAINT [FK_turnopaciente_Medico]
GO
ALTER TABLE [dbo].[turnopaciente] WITH CHECK ADD CONSTRAINT [FK_turnopaciente_paciente] FOREIGN KEY([idPaciente])
REFERENCES [dbo].[paciente] ([idPaciente])
GO
-- FK_turnopaciente_paciente: Vincula cada asignación de turno en turnopaciente con el paciente que solicitó el turno en la tabla paciente.
ALTER TABLE [dbo].[turnopaciente] CHECK CONSTRAINT [FK_turnopaciente_paciente]
GO
ALTER TABLE [dbo].[turnopaciente] WITH CHECK ADD CONSTRAINT [FK_turnopaciente_turno] FOREIGN KEY([idTurno])
REFERENCES [dbo].[turno] ([idTurno])
GO
-- FK_turnopaciente_turno: Vincula cada asignación de turno en turnopaciente con la información del turno en la tabla turno.
ALTER TABLE [dbo].[turnopaciente] CHECK CONSTRAINT [FK_turnopaciente_turno]
GO
USE [master]
GO
ALTER DATABASE [Centro_Medico] SET READ_WRITE
GO

USE [Centro_Medico]
GO

SELECT * FROM dbo.pais
SELECT * FROM dbo.paciente
SELECT * FROM dbo.medico

--Insertar paises
INSERT INTO dbo.pais (idPais, pais) VALUES
('ARG', 'Argentina'),
('BRA', 'Brasil'),
('COL', 'Colombia'),
('ESP', 'España'),
('MEX', 'Mexico'),
('PER', 'Peru');

--Insertar pacientes
INSERT INTO dbo.paciente (DNI, nombre, apellido, fechaNacimiento, domicilio, idPais, telefono, email, observacion)
VALUES
(13221214, 'Maria', 'Fernandez', '1990-07-18', 'Piedras 272', 'ARG', '11 5431-5522', 'maria@gmail.com', ''),
(18455382, 'Candela', 'Martinez', '2006-03-04', 'Av. Siempre Viva 742', 'MEX', '55 1234-5678', 'candela@gmail.com', ''),
(84773910, 'Sofia', 'Ramirez', '2005-09-24', 'Falsa 123', 'ESP', '91 1234-5678', 'sofia.ramirez@hotmail.com', ''),
(81345742, 'Carlos', 'Gomez', '1978-09-15', 'Carrera 121', 'COL', '1 4321-8765', 'carlos@hotmail.com', '');

--Insertar Medico
INSERT INTO dbo.medico (nombre, apellido)
VALUES ('Aaron', 'Warner');