-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREPCIRCULOPM
DELIMITER ;
DROP TABLE IF EXISTS TMPREPCIRCULOPM;

DELIMITER $$
CREATE TABLE `TMPREPCIRCULOPM` (
	`RegistroID_PK` bigint UNSIGNED AUTO_INCREMENT,
	RegistroID 				BIGINT(12)		NOT NULL COMMENT 'Número de Registro',
	Transaccion 			BIGINT(20) 		NOT NULL COMMENT 'Número de Transaccion',
	CreditoID 				BIGINT(12) 		NOT NULL COMMENT 'Número de Credito',

	RFC						VARCHAR(13) 	NOT NULL COMMENT 'RFC del acreditado',
	CURP					VARCHAR(18) 	NOT NULL COMMENT 'CURP del acreditado',
	RazonSocial				VARCHAR(150)	NOT NULL COMMENT 'Razon Social (Persona Moral) del acreditado',
	PrimerNombre			VARCHAR(30) 	NOT NULL COMMENT 'Primer Nombre del acreditado',
	SegundoNombre			VARCHAR(30) 	NOT NULL COMMENT 'Segundo Nombre del acreditado',

	ApellidoPaterno			VARCHAR(25) 	NOT NULL COMMENT 'Apellido Parterno del acreditado',
	ApellidoMaterno			VARCHAR(25)		NOT NULL COMMENT 'Apellido Materno del acreditado',
	Nacionalidad			VARCHAR(2)		NOT NULL COMMENT 'Nacionalidad del acreditado (ANEXO 6 de PAISES)',
	ClasificacionCartera	VARCHAR(2)		NOT NULL COMMENT 'Clasificación de Cartera (ANEXO 3 Clasificación de Cartera)',
	ClaveBanxico1			VARCHAR(11)		NOT NULL COMMENT 'Código Banxico 1',

	ClaveBanxico2			VARCHAR(11)		NOT NULL COMMENT 'Código Banxico 2',
	ClaveBanxico3			VARCHAR(11)		NOT NULL COMMENT 'Código Banxico 3',
	Direccion1				VARCHAR(40) 	NOT NULL COMMENT 'Dirección 1 del acreditado',
	Direccion2				VARCHAR(40) 	NOT NULL COMMENT 'Dirección 2 del acreditado',
	Colonia 				VARCHAR(60) 	NOT NULL COMMENT 'Colonia del acreditado',

	Municipio				VARCHAR(40) 	NOT NULL COMMENT 'Delegación o Municipio del acreditado',
	Ciudad					VARCHAR(40) 	NOT NULL COMMENT 'Ciudad del acreditado',
	Estado					VARCHAR(4) 		NOT NULL COMMENT 'Estado del acreditado (ANEXO 7 Esatos de la Republica)',
	CodigoPostal			VARCHAR(10) 	NOT NULL COMMENT 'Código Postal del acreditado (Lista de SEPOMEX)',
	Telefono 				VARCHAR(11) 	NOT NULL COMMENT 'Número de Teléfono del acreditado',

	Extension				VARCHAR(8)		NOT NULL COMMENT 'Extensión de Teléfono del acreditado',
	Fax						VARCHAR(11) 	NOT NULL COMMENT 'Número de Fax del acreditado',
	TipoCliente				CHAR(1) 		NOT NULL COMMENT 'Tipo de Cliente \n1.- Persona \n2.- Persona Física con Actividad Empresarial \n3.- Fideicomiso \n4.-Gobierno \nPersona Moral PYME',
	EdoExtranjero			VARCHAR(40) 	NOT NULL COMMENT 'Nombre del Estado en el País Extranjero del acreditado',
	Pais					VARCHAR(2) 		NOT NULL COMMENT 'País Origen del Domicilio acreditado (ANEXO 6 de PAISES)',

	TelefonoCelular 		VARCHAR(15) 	NOT NULL COMMENT 'Número de Teléfono Celular del acreditado',
	Correo 					VARCHAR(100) 	NOT NULL COMMENT 'Correo Electronico del acreditado',
	Monto					decimal(14,2)	DEFAULT NULL COMMENT 'Monto capturado en pantalla',
  	FechaIngreso			date			DEFAULT NULL COMMENT 'Fecha de ingreso',

	NumeroContratoAnt 		VARCHAR(25)		NOT NULL COMMENT 'Número de Crédito Anterior(Restructura)',
	FechaApertura 			VARCHAR(8)		NOT NULL COMMENT 'Fecha de Apertura del Crédito',
	PlazoCredito			INT(6)			NOT NULL COMMENT 'Plazo del Crédito',
	TipoCredito				VARCHAR(4)		NOT NULL COMMENT 'Tipo de Crédito',
	SaldoInicial 			INT(20)			NOT NULL COMMENT 'Monto del Crédito Otorgado',

	Moneda 					VARCHAR(3)		NOT NULL COMMENT 'Tripo de Moneda con el que se aperturó el crédito',
	NumeroPagos 			INT(4)			NOT NULL COMMENT 'Número de Pagos acordados(Amortizaciones)',
	FrecuenciaPago 			INT(5)			NOT NULL COMMENT 'Frecuencia de Pago del Crédito',
	ImportePago 			INT(20)			NOT NULL COMMENT 'Monto de Pago Acordado por Pago del Crédito',
	FechaUltimoPago			VARCHAR(8)		NOT NULL COMMENT 'Fecha de Apertura del Crédito',

	FechaRestructura		VARCHAR(8)		NOT NULL COMMENT 'Fecha de Reestructura del Crédito',
	PagoCredito 			INT(20)			NOT NULL COMMENT 'Monto de Pago del Crédito',
	FechaLiquidacion		VARCHAR(8)		NOT NULL COMMENT 'Fecha de Liquidación del Crédito',
	Quita					INT(20)			NOT NULL COMMENT 'Descuento otorgado al Crédito',
	Dacion					INT(20)			NOT NULL COMMENT 'Importo que fue dado como parte del crédito',

	Castigo					INT(20)			NOT NULL COMMENT 'Monto de castigo otorgado al Crédito',
	ClaveObservacion 		VARCHAR(4)		NOT NULL COMMENT 'Estatus del Crédito',
	Especiales 				CHAR(1)			NOT NULL COMMENT 'Cuando un Crédito es especial',
	FechaIncumplimiento 	VARCHAR(8)		NOT NULL COMMENT 'Fecha de Primer Incumplimiento del Crédito',
	SaldoInsoluto 			INT(8)			NOT NULL COMMENT 'Saldo Capital del Crédito',

	CreditoMaximo			INT(20)			NOT NULL COMMENT 'Monto de castigo otorgado al Crédito',
	FechaCartVencida		VARCHAR(8)		NOT NULL COMMENT 'Fecha de Cartera Vencida del Crédito',
	DiasVencidos			INT(3)			NOT NULL COMMENT 'Días vencidos del Crédito',
	SaldoTotal 				INT(20)			NOT NULL COMMENT 'Saldo Total de la Deuda',
	Interes 				INT(20)			NOT NULL COMMENT 'Interes de la Deuda',

	RFCAccionista			VARCHAR(13) 	NOT NULL COMMENT 'RFC del Accionista',
	CURPAccionista			VARCHAR(18) 	NOT NULL COMMENT 'CURP del Accionista',
	RazonSocAccionista		VARCHAR(150)	NOT NULL COMMENT 'Razon Social (Persona Moral) del Accionista',
	PrimerNomAccionista		VARCHAR(30) 	NOT NULL COMMENT 'Primer Nombre del Accionista',
	SegundoNomAccionista	VARCHAR(30) 	NOT NULL COMMENT 'Segundo Nombre del Accionista',

	ApePaternoAccionista	VARCHAR(25) 	NOT NULL COMMENT 'Apellido Parterno del Accionista',
	ApeMaternoAccionista	VARCHAR(25)		NOT NULL COMMENT 'Apellido Materno del Accionista',
	Porcentaje				CHAR(2)			NOT NULL COMMENT 'Porcentaje de Acciones',
	DireccionAccionista1	VARCHAR(40) 	NOT NULL COMMENT 'Dirección 1 del Accionista',
	DireccionAccionista2	VARCHAR(40) 	NOT NULL COMMENT 'Dirección 2 del Accionista',

	ColoniaAccionista 		VARCHAR(60) 	NOT NULL COMMENT 'Colonia del Accionista',
	MunicipioAccionista		VARCHAR(40) 	NOT NULL COMMENT 'Delegación o Municipio del Accionista',
	CiudadAccionista		VARCHAR(40) 	NOT NULL COMMENT 'Ciudad del Accionista',
	EstadoAccionista		VARCHAR(4) 		NOT NULL COMMENT 'Estado del Accionista (ANEXO 7 Esatos de la Republica)',
	CPAccionista			VARCHAR(10) 	NOT NULL COMMENT 'Código Postal del Accionista (Lista de SEPOMEX)',

	TelefonoAccionista 		VARCHAR(11) 	NOT NULL COMMENT 'Número de Teléfono del Accionista',
	ExtAccionista			VARCHAR(8)		NOT NULL COMMENT 'Extensión de Teléfono del Accionista',
	FaxAccionista			VARCHAR(11) 	NOT NULL COMMENT 'Número de Fax del Accionista',
	TipClieAccionista		CHAR(1) 		NOT NULL COMMENT 'Tipo de Cliente \n1.- Persona \n2.-Persona Física con Actividad Empresarial \n3.- Fideicomiso \n4.-Gobierno \nPersona Moral PYME',
	EdoExtAccionista		VARCHAR(40) 	NOT NULL COMMENT 'Nombre del Estado en el País Extranjero del Accionista',

	PaisAccionista			VARCHAR(2) 		NOT NULL COMMENT 'País Origen del Domicilio Accionista (ANEXO 6 de PAISES)',

	RFCAval 				VARCHAR(13) 	NOT NULL COMMENT 'RFC del Aval',
	CURPAval 				VARCHAR(25) 	NOT NULL COMMENT 'CURP del Aval',
	RazonSocAval 			VARCHAR(150) 	NOT NULL COMMENT 'Razon Social (Persona Moral) del Aval',
	PrimerNomAval 			VARCHAR(30) 	NOT NULL COMMENT 'Primer Nombre del Aval',
	SegundoNomAval			VARCHAR(30) 	NOT NULL COMMENT 'Segundo Nombre del Aval',

	ApePaternoAval			VARCHAR(25) 	NOT NULL COMMENT 'Apellido Parterno del Aval',
	ApeMaternoAval			VARCHAR(25) 	NOT NULL COMMENT 'Apellido Materno del Aval',
	DireccionAval1 			VARCHAR(40) 	NOT NULL COMMENT 'Dirección 1 del Aval',
	DireccionAval2 			VARCHAR(40) 	NOT NULL COMMENT 'Dirección 2 del Aval',
	ColoniaAval 			VARCHAR(60)		NOT NULL COMMENT 'Colonia del Aval',

	MunicipioAval 			VARCHAR(40) 	NOT NULL COMMENT 'Delegación o Municipio del Aval',
	CiudadAval 				VARCHAR(40) 	NOT NULL COMMENT 'Ciudad del Aval',
	EstadoAval 				VARCHAR(4) 		NOT NULL COMMENT 'Estado del Aval (ANEXO 7 Esatos de la Republica)',
	CPAval	 				VARCHAR(10) 	NOT NULL COMMENT 'Código Postal del Aval (Lista de SEPOMEX)',
	TelefonoAval 			VARCHAR(11) 	NOT NULL COMMENT 'Número de Teléfono del Aval',

	ExtAval 				VARCHAR(8) 		NOT NULL COMMENT 'Extensión de Teléfono del Aval',
	FaxAval 				VARCHAR(11) 	NOT NULL COMMENT 'Número de Fax del Aval',
	TipClieAval 			CHAR(1) 		NOT NULL COMMENT 'Tipo de Cliente \n1.- Persona \n2.- Persona Física con Actividad Empresarial \n3.- Fideicomiso \n4.-Gobierno \nPersona Moral PYME',
	EdoExtAval 				VARCHAR(40) 	NOT NULL COMMENT 'Nombre del Estado en el País Extranjero del Aval',
	PaisAval 				VARCHAR(2) 		NOT NULL COMMENT 'País Origen del Domicilio Aval (ANEXO 6 de PAISES)',
	PRIMARY KEY (`RegistroID_PK`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal para la Obtención del Reporte a Círculo de Crédito para Personas Morales y Físicas con Act. Empresarial'$$
