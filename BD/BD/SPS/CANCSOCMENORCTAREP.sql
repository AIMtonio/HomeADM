-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCSOCMENORCTAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCSOCMENORCTAREP`;DELIMITER $$

CREATE PROCEDURE `CANCSOCMENORCTAREP`(
	Par_ClienteID			INT(11),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN

-- Declaracion e Variables
DECLARE Var_CliArchID			INT;
DECLARE Var_ClienteID			INT(11);
DECLARE Var_NombreCompleto		VARCHAR(200);
DECLARE Var_FechaCancela		DATE;
DECLARE Var_DireccionCompleta	VARCHAR(200);
DECLARE Var_SucursalOrigen		INT(11);
DECLARE Var_NombreSucursal		VARCHAR(200);
DECLARE Var_SaldoAhorro			DECIMAL(14,2);
DECLARE Var_Recurso				VARCHAR(500);
DECLARE Var_NombreMunicipio		VARCHAR(200);

/* DECLARACION DE CONSTANTES */
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(12,2);
DECLARE Fecha_Vacia			DATE;
DECLARE Inactivo			CHAR(1);
DECLARE Tipo_Inactivacion	INT(11);
DECLARE Desc_Inactiva		VARCHAR(100);
DECLARE EsMenor				CHAR(1);
DECLARE Activo				CHAR(1);
DECLARE Cancelada			CHAR(1);
DECLARE TipoDoc				INT(11);
/*Asignacion de Constantes*/
SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Decimal_Cero			:= 0.0;
SET Inactivo				:='I';	/*Estatus Inactivo*/
SET Tipo_Inactivacion		:=11;   /*Tipo de Inactivacion Mayor de Edad*/
SET Desc_Inactiva			:=" ";
SET EsMenor					:="S";  /*Si es menor de Edad*/
SET Activo					:="A";  /*Estatus Activo*/
SET Cancelada				:="C";
SET TipoDoc					:=1	;	/* -- Tipo Documento Imagen o Foto del Cliente*/

 SELECT  MAX(ClienteArchivosID)
		INTO Var_CliArchID
        FROM CLIENTEARCHIVOS
			WHERE ClienteID     = Par_ClienteID
			AND TipoDocumento 	= TipoDoc;

 SET Var_CliArchID   := IFNULL(Var_CliArchID, Entero_Cero);

		SELECT  IFNULL(Recurso,"0") INTO Var_Recurso
			FROM CLIENTEARCHIVOS
			WHERE ClienteArchivosID = Var_CliArchID;


	SELECT Can.ClienteID,  		Cli.NombreCompleto,	MAX(Can.FechaCancela),MAX(Dir.DireccionCompleta),Cli.SucursalOrigen,
		   Suc.NombreSucurs,	SUM(Can.SaldoAhorro)
	  INTO Var_ClienteID,		Var_NombreCompleto,	Var_FechaCancela,Var_DireccionCompleta,Var_SucursalOrigen,
		   Var_NombreSucursal,	Var_SaldoAhorro
			FROM CANCSOCMENORCTA Can
					INNER JOIN CLIENTES Cli ON Cli.ClienteID=Can.ClienteID
					LEFT JOIN DIRECCLIENTE Dir ON Dir.ClienteID=Cli.ClienteID AND Oficial="S"
					INNER JOIN SUCURSALES Suc ON Suc.SucursalID=Cli.SucursalOrigen
				WHERE Can.ClienteID=Par_ClienteID
					AND Can.Aplicado="N";

	SELECT Mun.Nombre INTO Var_NombreMunicipio
			FROM SUCURSALES Suc
				INNER JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID=Suc.EstadoID AND Mun.MunicipioID=Suc.MunicipioID
				WHERE SucursalID=Aud_Sucursal;

	SELECT Var_ClienteID,		Var_NombreCompleto,	Var_FechaCancela,	Var_DireccionCompleta,
		   Var_NombreSucursal,	Var_SucursalOrigen,	Var_SaldoAhorro,	Var_Recurso,
		   Var_NombreMunicipio;

END TerminaStore$$