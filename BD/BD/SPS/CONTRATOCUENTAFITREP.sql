-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATOCUENTAFITREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATOCUENTAFITREP`;DELIMITER $$

CREATE PROCEDURE `CONTRATOCUENTAFITREP`(
/* Procedimiento para obtener los datos deL CONTRATO DE AHORRO de personas Fisicas y Morales - FINANCIERA TAMAZULA*/
	Par_CuentaAhoID				BIGINT(12),		-- no. de cuenta para cual se genera la caratula de contrato
	Par_SucursalID				INT(11),		-- sucursal del usuario logueado

    Par_EmpresaID       		INT,
    Aud_Usuario         		INT,
    Aud_FechaActual     		DATETIME,
    Aud_DireccionIP     		VARCHAR(15),
    Aud_ProgramaID      		VARCHAR(50),
    Aud_Sucursal        		INT(11),
    Aud_NumTransaccion  		BIGINT
	)
TerminaStore: BEGIN

# Declaracion de variables

DECLARE Var_NumeroCuenta		BIGINT(12);			-- Numero de Cuenta de Ahorro
DECLARE Var_NombreProducto		VARCHAR(30);		-- Nombre del Producto de Ahorro
DECLARE Var_RECA 				VARCHAR(100);		-- Num RECA del Producto de Ahorro
DECLARE Var_SaldoMenorReq		DECIMAL(12,2);		-- Saldo menor requerido en la cuenta de ahorro
DECLARE Var_GAT 				DECIMAL(12,2);		-- Valor GAT de la cuenta
DECLARE Var_GATReal 			DECIMAL(12,2);		-- Valor GAT REAL de la cuenta
DECLARE Var_TasaInteres			DECIMAL(12,2);		-- Tasa de Intereses de la cuenta
DECLARE Var_TasaInteresLetra	VARCHAR(50);		-- Tasa de Interes en letra
DECLARE Var_TipoProductoRep		CHAR(1);			-- Tipo de Producto de Ahorro

DECLARE Var_NumeroCliente		INT(11);			-- ClienteID
DECLARE Var_TipoPersona			CHAR(1);			-- Tipo Persona F: Fisica, M: Moral, A: Fisica con Act Empresarial
DECLARE Var_RazonSocial			VARCHAR(150);		-- Razon Social del cliente
DECLARE Var_NombreRepLegal		VARCHAR(150);		-- Nombre del Representante Legal del cliente Moral
DECLARE Var_NombreCliente		VARCHAR(150);		-- Nombre del cliente
DECLARE Var_SoloNombres			VARCHAR(70);		-- Solo Nombres del cliente
DECLARE Var_SoloApellidos		VARCHAR(70);		-- Apellidos del cliente
DECLARE Var_EsMenor				CHAR(1);			-- Si/No el cliente es menor

DECLARE Var_DirecCalle      	VARCHAR(50);		-- Calle de la Direccion Oficial del CLiente
DECLARE Var_DirecNumExt     	CHAR(10);			-- Numero Exterior de la Direccion Oficial del cliente
DECLARE Var_DirecNumInt			CHAR(10);			-- NUmero Interior de la Direccion Oficial del cliente
DECLARE Var_DirecColonia    	VARCHAR(200);		-- Colonia de la Direccion Oficial del cliente
DECLARE Var_DirecCP         	CHAR(5);			-- Codigo Postal de la Direccion Oficial del cliente
DECLARE Var_DirecMuni       	VARCHAR(150);		-- Municipio de la Direccion Oficial del cliente
DECLARE Var_DirecEstado     	VARCHAR(100);		-- Nombre del estado de la Direccion Oficial del cliente

DECLARE Var_NumEscrituraPub		VARCHAR(50);		-- Numero de la escritura Publica
DECLARE Var_NumNotaria			INT(11);			-- Numero de Notaria
DECLARE Var_DomicilioNotaria 	VARCHAR(150);		-- Domicilio de la Notaria
DECLARE Var_NombreNotario 		VARCHAR(100);		-- Nombre del Notario
DECLARE Var_FechaEscritura 		DATE;				-- Fecha de la Escritura Publica
DECLARE Var_FolioEScritura		VARCHAR(10);
DECLARE Var_EstadoNotaria 		VARCHAR(100);		-- Estado de la Notaria
DECLARE Var_MuniNotaria 		VARCHAR(150);		-- Municipio de la Notaria

DECLARE Var_NombreApoderado		VARCHAR(100);		-- Nombre del representante legal de la empresa
DECLARE Var_Jurisdiccion		VARCHAR(150);		-- Jurisdiccion a la que pertenece la sucursal del cliente
DECLARE Var_DirecMenor			VARCHAR(500);		-- Direccion de un cliente menor de edad
DECLARE Var_DirecCliente		VARCHAR(500);		-- Direccion de un cliente

DECLARE Var_Encabezado			VARCHAR(650);		-- Representa el primer parrafo del contrato
DECLARE Var_GATLetra			VARCHAR(300);		-- Representa el parrafo con la GAT
DECLARE Var_GATRealLetra		VARCHAR(350);		-- Representa el parrafo con la GAT REAL
DECLARE Var_SaldoMinimoC		VARCHAR(350);		-- Representa el parrafo con el saldo minimo requerido en la cuenta


# Declaracion de Constantes
DECLARE Str_Si				CHAR(1);				-- Constante S
DECLARE Str_No				CHAR(1);				-- Constante N
DECLARE Str_Vigente			CHAR(1);				-- Constante V
DECLARE Str_Cancelada		CHAR(1);				-- Constante C
DECLARE Str_PF				CHAR(1);				-- Constante F de Persona Fisica
DECLARE Str_PM				CHAR(1);				-- Constante M de Persona Moral
DECLARE Str_PA				CHAR(1);				-- Constante A de Persona Fisica con Act Empresarial
DECLARE Decimal_Cero		DECIMAL(2,2);			-- Constante DECIMAL CERO
DECLARE Cadena_Vacia		CHAR(1);				-- Cadena Vacia
DECLARE Str_F 				CHAR(1); 				-- Constante F para tipo de Ahorro FIT
DECLARE Str_I 				CHAR(1); 				-- Constante F para tipo de Ahorro Infantil
DECLARE Str_J 				CHAR(1); 				-- Constante F para tipo de Ahorro Juvenil
DECLARE Str_O 				CHAR(1); 				-- Constante F para Cuenta de Tipo Operativa
DECLARE Ahorro_Infantil		VARCHAR(15);			-- Ahorro Infantil
DECLARE Ahorro_Juvenil 		VARCHAR(15);			-- Ahorro Juvenil
DECLARE Ahorro_FIT 			VARCHAR(10);			-- Ahorro FIT
DECLARE Cuenta_Operativa	VARCHAR(20);			-- Cuenta Operativa

DECLARE Long_Linea 			INT(3);					-- Longitud en caracteres de la linea del parrafo
DECLARE Num_LinEn			TINYINT;				-- Numero de Lineas del encabezado Contrato PM
DECLARE Num_LinEnPF			TINYINT;				-- Numero de Lineas del encabezado Contrato PF
DECLARE Num_LinGAT			TINYINT;				-- Numero de Lineas del parrafo GAT
DECLARE Num_LinGATReal		TINYINT;				-- Numero de Lineas del parrafo GAT REAL
DECLARE Num_LinSaldoMin		TINYINT;				-- Numero de Lineas del parrafo de Saldo Minimo



# Asigancion de Constantes
SET Str_Si				:= 'S';
SET Str_No				:= 'N';
SET Str_Vigente			:= 'V';
SET Str_Cancelada		:= 'C';
SET Str_PF				:= 'F';
SET Str_PM				:= 'M';
SET Str_PA				:= 'A';
SET Decimal_Cero 		:= 00.00;
SET Cadena_Vacia		:= '';
SET Str_F 				:= 'F';
SET Str_I 				:= 'I';
SET Str_J 				:= 'J';
SET Str_O 				:= 'O';
SET Ahorro_Infantil		:= 'Ahorro Infantil';
SET Ahorro_Juvenil 		:= 'Ahorro Juvenil';
SET Ahorro_FIT 			:= 'Ahorro FIT';
SET Cuenta_Operativa	:= 'Cuenta Operativa';
SET Long_Linea			:= 118;
SET Num_LinEn			:= 5;
SET Num_LinEnPF			:= 4;
SET Num_LinGAT 			:= 2;
SET Num_LinGATReal 		:= 2;
SET Num_LinSaldoMin		:= 3;


SELECT
	CA.CuentaAhoID,				TC.Descripcion,				TC.NumRegistroRECA,				TC.SaldoMInReq,
	CA.Gat,						CA.GatReal,					CA.TasaInteres,					CA.ClienteID,
    CLI.TipoPersona
INTO
	Var_NumeroCuenta,			Var_NombreProducto,			Var_RECA,						Var_SaldoMenorReq,
	Var_GAT,					Var_GATReal,				Var_TasaInteres,				Var_NumeroCliente,
	Var_TipoPersona
FROM CUENTASAHO CA
	INNER JOIN TIPOSCUENTAS TC ON TC.TipoCuentaID = CA.TipoCuentaID
    INNER JOIN CLIENTES CLI ON CLI.ClienteID = CA.ClienteID
	WHERE CA.CuentaAhoID = Par_CuentaAhoID;





-- DATOS DE FIT
SELECT
	PS.NombreRepresentante
INTO
	Var_NombreApoderado
FROM PARAMETROSSIS PS LIMIT 1;


SET Var_TasaInteresLetra :=	CASE
						WHEN ((SELECT FORMAT (Var_TasaInteres, 2)) = Decimal_Cero) THEN
							(SELECT FUNCIONSOLONUMLETRAS(Var_TasaInteres))
						WHEN ((SELECT FORMAT (Var_TasaInteres, 2)) != Decimal_Cero) THEN
							(SELECT FUNCIONNUMEROSLETRAS(Var_TasaInteres))
END ;

SET Var_GATLetra 	:=	(SELECT  CONCAT('{\\rtf1 {\\b GAT NOMINAL.- ', IFNULL(Var_GAT, Decimal_Cero),'%( ',
	CONCAT(	CONCAT(IF (FUNCIONNUMEROSLETRAS(Var_GAT) = Cadena_Vacia, 'CERO', FUNCIONNUMEROSLETRAS(Var_GAT))) ) ,' por ciento) } Antes de impuestos, para fines informativos y de comparación.'));

SET Var_GATRealLetra 	:=	(SELECT CONCAT('{\\rtf1 {\\b GAT REAL.- ',IFNULL(Var_GATReal, Decimal_Cero) ,'% (',
	CONCAT(IF (FUNCIONNUMEROSLETRAS(Var_GATReal) = Cadena_Vacia, 'CERO', FUNCIONNUMEROSLETRAS(Var_GATReal))) ,'  por ciento) } Antes de impuestos, para fines informativos y de',
	' comparación. La {\\b GAT REAL}, es el rendimiento que obtendría después',
	' de descontar la inflación estimada.'));





IF(Var_TipoPersona = Str_PM) THEN
	-- DIRECCION DEL CLIENTE
SELECT
	DIR.Calle,          			DIR.NumeroCasa,      		DIR.NumInterior,			DIR.Colonia,
	DIR.CP,    						MUNI.Nombre,				EST.Nombre
INTO
	Var_DirecCalle,					Var_DirecNumExt,			Var_DirecNumInt,			Var_DirecColonia,
	Var_DirecCP,					Var_DirecMuni,				Var_DirecEstado
FROM CLIENTES CLI
	INNER JOIN DIRECCLIENTE   DIR       ON CLI.ClienteID = DIR.ClienteID    AND DIR.Fiscal = Str_Si
	INNER JOIN ESTADOSREPUB   EST       ON  DIR.EstadoID = EST.EstadoID
	INNER JOIN MUNICIPIOSREPUB  MUNI    ON DIR.EstadoID = MUNI.EstadoID     AND DIR.MunicipioID = MUNI.MunicipioID
	INNER JOIN LOCALIDADREPUB   LOC     ON DIR.EstadoID = LOC.EstadoID      AND DIR.MunicipioID = LOC.MunicipioID   AND DIR.LocalidadID = LOC.LocalidadID
	LEFT OUTER JOIN COLONIASREPUB COL   ON DIR.EstadoID = COL.EstadoID      AND DIR.MunicipioID = COL.MunicipioID   AND DIR.ColoniaID = COL.ColoniaID
	WHERE CLI.ClienteID = Var_NumeroCliente;

	-- DATOS DE LA ESCRITURA
	SELECT
		EP.EscrituraPublic, 		EP.Notaria,					EP.DirecNotaria,			EP.NomNotario,
		EP.FechaEsc,				EP.FolioRegPub, 			EST.Nombre,					MUNI.Nombre
	INTO
		Var_NumEscrituraPub,		Var_NumNotaria,				Var_DomicilioNotaria,		Var_NombreNotario,
		Var_FechaEscritura,			Var_FolioEScritura,			Var_EstadoNotaria,			Var_MuniNotaria
	FROM  ESCRITURAPUB EP
	INNER JOIN CLIENTES CLI  ON CLI.ClienteID = EP.ClienteID
	INNER JOIN ESTADOSREPUB EST ON EST.EstadoID = EP.EstadoIDReg
	INNER JOIN MUNICIPIOSREPUB MUNI ON MUNI.MunicipioID = EP.LocalidadRegPub AND EST.EstadoID = MUNI.EstadoID
	AND CLI.ClienteID = Var_NumeroCliente AND EP.Estatus = Str_Vigente ORDER BY EP.Consecutivo ASC LIMIT 1;



	-- INFORMACION DEL CLIENTE DE LA CUENTA DE AHORRO
	SELECT
		CLI.RazonSocial,			CP.NombreCompleto,			CLI.NombreCompleto
	INTO
		Var_RazonSocial,			Var_NombreRepLegal,			Var_NombreCliente
	FROM CUENTASAHO CA
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = CA.ClienteID
		LEFT JOIN CUENTASPERSONA CP ON CP.CuentaAhoID = CA.CuentaAhoID AND CP.EsApoderado = Str_Si
		WHERE CA.CuentaAhoID = Par_CuentaAhoID
		ORDER BY CP.PersonaID LIMIT 1;

	SET Var_DirecCliente := (SELECT CONCAT(Var_DirecCalle,
			' No. Ext. ', Var_DirecNumExt, ' (',
				(SELECT IF(Var_DirecNumExt = Cadena_Vacia OR Var_DirecNumExt = NULL ,  'S/N', FNNUMVIVIENDALETRA(Var_DirecNumExt))),
			 '), No. INT. ', Var_DirecNumInt, ' (',
			 	(SELECT IF(Var_DirecNumInt = Cadena_Vacia OR Var_DirecNumInt = NULL , 'S/N', FNNUMVIVIENDALETRA(Var_DirecNumInt))),
							'), ', IFNULL(Var_DirecColonia, ''), ', ', IFNULL(Var_DirecMuni, ''), ', ', IFNULL(Var_DirecEstado, ''), ', MEXICO, ', IFNULL(Var_DirecCP, '')));


	SET Var_Encabezado	:=	(SELECT CONCAT('{\\rtf1 Contrato de apertura de {\\b ',Var_NombreProducto, '}, que celebran por un parte FINANCIERA',
		' TAMAZULA S.A. DE C.V. S.F.P., a quien en lo sucesivo se denominará “LA SOCIEDAD”, representada en este acto por',
		' su Representante Legal, el {\\b C. ',Var_NombreApoderado ,'} y por otra parte  la persona jurídica. Denominada {\\b ',CONCAT(IFNULL(Var_RazonSocial, Var_NombreCliente) , '},',
		' representada en este acto por su representante legal  el {\\b C. ',IFNULL(Var_NombreRepLegal, Cadena_Vacia) ,'} en lo sucesivo “EL CLIENTE” de',
		' conformidad con las siguientes declaraciones y clausulas: ')));


	SET Var_SaldoMinimoC :=	(SELECT CONCAT('{\\rtf1 {\\b SÉPTIMA.- SALDO MÍNIMO.- } El saldo mínimo para mantener',
		' vigente la cuenta será de {\\b $',Var_SaldoMenorReq,' } (', CONCAT((SELECT FUNCIONNUMLETRAS(Var_SaldoMenorReq))) ,' M. N.).',
		' Cuando no se cumpla con esta condición no se generarán rendimientos sobre las cantidades depositadas por “EL CLIENTE”. '));


		SELECT
			Var_NombreProducto AS NombreProducto,			Var_RECA AS RECA, 							Var_SaldoMenorReq AS SaldoMinimo,
			Var_GAT AS GAT,									Var_GATReal AS GATReal,						Var_TipoPersona AS TipoPersona,
			Var_NombreRepLegal AS NombreRepLegal,			Var_NumEscrituraPub AS NumEscritura,		Var_NumNotaria AS NumNotaria,
			Var_DomicilioNotaria AS DomicilioNotarial,		Var_NombreNotario AS NombreNotario, 		Var_FechaEscritura AS FechaEscritura,
			Var_FolioEScritura AS FolioEscritura,			Var_NombreApoderado AS NombreApoderado, 	Var_TasaInteresLetra AS TasaInteresLetra,

			Var_DirecCliente AS DomicilioCliente,			Var_Encabezado AS Var_Encabezado, 			Var_GATLetra AS GATLetra,
			Var_GATRealLetra AS GATRealLetra,				Var_SaldoMinimoC AS SaldoMin,				Long_Linea AS Var_LongLinea,
			Num_LinEn AS Var_NumLineas, 					Num_LinGAT AS Var_NumLinGAT, 				Num_LinGATReal AS Var_NumLinGATReal,
			Num_LinSaldoMin AS Var_NumLinSaldoMin,

			(LPAD(Var_NumeroCuenta, 11, 0))  AS NumeroCuenta,
			(LPAD(Var_NumeroCliente, 11, 0))  AS NumeroCliente,
			(DATE_FORMAT(Aud_FechaActual, "%d/%m/%Y")) AS FechaActual,
			CONCAT(IFNULL(Var_RazonSocial, Var_NombreCliente)) AS NombreCliente,
			CONCAT(Var_MuniNotaria, ', ', Var_EstadoNotaria ) AS SedeNotaria,

			CONCAT((FORMAT (Var_TasaInteres, 2))) AS TasaInteres,
			CONCAT((FUNCIONNUMLETRAS(Var_SaldoMenorReq))) AS SaldoMinLetra,
			CONCAT((FNFECHACOMPLETA(Aud_FechaActual, 3))) AS FechaActualLetra,
			CONCAT((FNFECHACOMPLETA(Var_FechaEscritura, 3))) AS FechaEscrituraLetra;



END IF;


IF(Var_TipoPersona = Str_PF OR Var_TipoPersona = Str_PA) THEN
	-- DIRECCION DEL CLIENTE
	SELECT
		DIR.Calle,          			DIR.NumeroCasa,      		DIR.NumInterior,			DIR.Colonia,
		DIR.CP,    						MUNI.Nombre,				EST.Nombre
	INTO
		Var_DirecCalle,					Var_DirecNumExt,			Var_DirecNumInt,			Var_DirecColonia,
		Var_DirecCP,					Var_DirecMuni,				Var_DirecEstado
	FROM CLIENTES CLI
		INNER JOIN DIRECCLIENTE   DIR       ON CLI.ClienteID = DIR.ClienteID    AND DIR.Oficial = Str_Si
		INNER JOIN ESTADOSREPUB   EST       ON  DIR.EstadoID = EST.EstadoID
		INNER JOIN MUNICIPIOSREPUB  MUNI    ON DIR.EstadoID = MUNI.EstadoID     AND DIR.MunicipioID = MUNI.MunicipioID
		INNER JOIN LOCALIDADREPUB   LOC     ON DIR.EstadoID = LOC.EstadoID      AND DIR.MunicipioID = LOC.MunicipioID   AND DIR.LocalidadID = LOC.LocalidadID
		LEFT OUTER JOIN COLONIASREPUB COL   ON DIR.EstadoID = COL.EstadoID      AND DIR.MunicipioID = COL.MunicipioID   AND DIR.ColoniaID = COL.ColoniaID
		WHERE CLI.ClienteID = Var_NumeroCliente;

	SELECT
		CLI.NombreCompleto,			CLI.EsMenorEdad,			TPF.TipoProductoRep
	INTO
		Var_NombreCliente,			Var_EsMenor,				Var_TipoProductoRep
	FROM CUENTASAHO CA
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = CA.ClienteID
	    INNER JOIN TIPOSCUENTAS TC ON TC.TipoCuentaID = CA.TipoCuentaID
	    INNER JOIN TIPOPRODUCTOFIT TPF ON TPF.TipoCuentaID = CA.TipoCuentaID
		WHERE CA.CuentaAhoID = Par_CuentaAhoID;


	SELECT
		MUNI.Nombre
	INTO
		Var_Jurisdiccion
	FROM CLIENTES CLI
		INNER JOIN SUCURSALES SUC 			ON SUC.SucursalID = CLI.SucursalOrigen
		INNER JOIN ESTADOSREPUB   EST       ON SUC.EstadoID = EST.EstadoID
		INNER JOIN MUNICIPIOSREPUB  MUNI    ON SUC.EstadoID = MUNI.EstadoID     AND SUC.MunicipioID = MUNI.MunicipioID
		INNER JOIN LOCALIDADREPUB   LOC     ON SUC.EstadoID = LOC.EstadoID      AND SUC.MunicipioID = LOC.MunicipioID   AND SUC.LocalidadID = LOC.LocalidadID
		LEFT OUTER JOIN COLONIASREPUB COL   ON SUC.EstadoID = COL.EstadoID      AND SUC.MunicipioID = COL.MunicipioID   AND SUC.ColoniaID = COL.ColoniaID
		WHERE CLI.ClienteID = Var_NumeroCliente;



SET Var_NombreProducto :=	CASE
						WHEN (Var_TipoProductoRep = Str_I) THEN Ahorro_Infantil
						WHEN (Var_TipoProductoRep = Str_O) THEN Cuenta_Operativa
						WHEN (Var_TipoProductoRep = Str_J) THEN Ahorro_Juvenil
						WHEN (Var_TipoProductoRep = Str_F) THEN Ahorro_FIT
END ;



	IF(Var_EsMenor = Str_Si) THEN
		SET Var_DirecMenor := (SELECT CONCAT(Var_DirecCalle,
			' No. Ext. ', Var_DirecNumExt, ' (',
				(SELECT IF(Var_DirecNumExt = Cadena_Vacia OR Var_DirecNumExt = NULL ,  'S/N', (SELECT FNNUMVIVIENDALETRA(Var_DirecNumExt)))),
			 '), No. INT. ', Var_DirecNumInt, ' (',
			 	(SELECT IF(Var_DirecNumInt = Cadena_Vacia OR Var_DirecNumInt = NULL , 'S/N', (SELECT FNNUMVIVIENDALETRA(Var_DirecNumInt)))),
							'), ', Var_DirecColonia, ', ', Var_DirecMuni, ', ', Var_DirecEstado, ', MEXICO, ', Var_DirecCP));

	ELSEIF(Var_EsMenor = Str_No) THEN
		SET Var_DirecCliente := (SELECT CONCAT(Var_DirecCalle,
			' No. Ext. ', Var_DirecNumExt, ' (',
				(SELECT IF(Var_DirecNumExt = Cadena_Vacia OR Var_DirecNumExt = NULL ,  'S/N', (SELECT FNNUMVIVIENDALETRA(Var_DirecNumExt)))),
			 '), No. INT. ', Var_DirecNumInt, ' (',
			 	(SELECT IF(Var_DirecNumInt = Cadena_Vacia OR Var_DirecNumInt = NULL , 'S/N', (SELECT FNNUMVIVIENDALETRA(Var_DirecNumInt)))),
							'), ', IFNULL(Var_DirecColonia, ''), ', ', IFNULL(Var_DirecMuni, ''), ', ', IFNULL(Var_DirecEstado, ''), ', MEXICO, ', IFNULL(Var_DirecCP, '')));
    END IF;


	SET Var_Encabezado	:=	(SELECT CONCAT('{\\rtf1 Contrato de apertura de {\\b ',Var_NombreProducto, ' }, que celebran',
		' por una parte FINANCIERA TAMAZULA S.A. DE C.V. S.F.P., a quien en lo sucesivo se denominará “LA SOCIEDAD”, representada',
		' en este acto por su Representante Legal, el {\\b C. ',Var_NombreApoderado ,' }  y por otra parte el  {\\b C. ',Var_NombreCliente ,', }',
		'en lo sucesivo “EL CLIENTE” de conformidad con las siguientes declaraciones y clausulas: '));

	SET Var_SaldoMinimoC :=	(SELECT CONCAT('{\\rtf1 {\\b DÉCIMA.- SALDO MÍNIMO.- } El saldo mínimo para mantener',
		' vigente la cuenta será de {\\b $',Var_SaldoMenorReq,' } (', CONCAT((SELECT FUNCIONNUMLETRAS(Var_SaldoMenorReq))) ,' M. N.).',
		' Cuando no se cumpla con esta condición no se generarán rendimientos sobre las cantidades depositadas por “EL CLIENTE”. '));


		SELECT
			Var_NombreProducto AS NombreProducto,			Var_RECA AS RECA, 							Var_SaldoMenorReq AS SaldoMinimo,
			Var_GAT AS GAT,									Var_GATReal AS GATReal,						Var_TipoPersona AS TipoPersona,
			Var_NombreRepLegal AS NombreRepLegal,			Var_NumEscrituraPub AS NumEscritura,		Var_NumNotaria AS NumNotaria,
			Var_NombreApoderado AS NombreApoderado, 		Var_TasaInteresLetra AS TasaInteresLetra,	Var_NombreCliente AS NombreCliente,
			Var_EsMenor AS Menor,							Var_TipoProductoRep AS TipoProducto,		Var_Jurisdiccion AS Jurisdiccion,

			Var_DirecMenor AS DirecMenor, 					Var_DirecCliente AS DirecCliente,			Var_SaldoMinimoC AS SaldoMin,
			Var_Encabezado AS Var_Encabezado,				Var_GATLetra AS GATLetra,					Var_GATRealLetra AS GATRealLetra,
			Long_Linea AS Var_LongLinea,					Num_LinEnPF AS Var_NumLineas, 				Num_LinGAT AS Var_NumLinGAT,
			Num_LinGATReal AS Var_NumLinGATReal,			Num_LinSaldoMin AS Var_NumLinSaldoMin,

			(LPAD(Var_NumeroCuenta, 11, 0))  AS NumeroCuenta,
			(LPAD(Var_NumeroCliente, 11, 0))  AS NumeroCliente,
			(DATE_FORMAT(Aud_FechaActual, "%d/%m/%Y")) AS FechaActual,
			CONCAT((FORMAT (Var_TasaInteres, 2))) AS TasaInteres,

			CONCAT((FUNCIONNUMLETRAS(Var_SaldoMenorReq))) AS SaldoMinLetra,
			CONCAT((FNFECHACOMPLETA(Aud_FechaActual, 3))) AS FechaActualLetra;

END IF;

END TerminaStore$$