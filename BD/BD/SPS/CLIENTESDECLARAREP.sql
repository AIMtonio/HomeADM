-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESDECLARAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESDECLARAREP`;DELIMITER $$

CREATE PROCEDURE `CLIENTESDECLARAREP`(

-- * *** STORE DE REPORTE PARA LA DECLARCION DE OPERACIONES POR CUENTA PROPIA O DE TERCEROS (PLD) ***
	Par_CuentaAhoID 		BIGINT(12),	-- Numero de la Cuenta de Ahorro
	-- Parametros de Auditoria
	Par_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),

	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT;
DECLARE	Decimal_Cero			DECIMAL(12,2);
DECLARE CuentaPrincipalSi		CHAR(1);
DECLARE TitularSi				CHAR(1);
DECLARE ProvRecursosSi			CHAR(1);
DECLARE PropRealSi				CHAR(1);
DECLARE DireccOfcialSi			CHAR(1);
DECLARE ConstanteSI				CHAR(1);
DECLARE ConstanteNO				CHAR(1);
DECLARE EstatusVigente			CHAR(1);
DECLARE menosVeinteMil			VARCHAR(50);
DECLARE veintemilCincuentamil	VARCHAR(50);
DECLARE cincuentamilCienmil		VARCHAR(50);
DECLARE mayorCienmil			VARCHAR(50);
DECLARE RelVigente              CHAR(1);

-- Declaracion de Variables
DECLARE Var_ClienteID 			INT(11);
DECLARE Var_CuentaAhoID 		BIGINT(12);
DECLARE Var_DirecCompleta		VARCHAR(500);
DECLARE Var_Relacionado			CHAR(1);

DECLARE Var_Nombres 			VARCHAR(150);
DECLARE Var_ApellidoPaterno 	VARCHAR(50);
DECLARE Var_ApellidoMaterno 	VARCHAR(50);
DECLARE Var_NombreCompleto 		VARCHAR(200);
DECLARE Var_CURP 				VARCHAR(18);
DECLARE Var_RFC					VARCHAR(13);
DECLARE Var_FEA					VARCHAR(250);
DECLARE Var_ActividadBMX		VARCHAR(15);
DECLARE Var_ActividadBMXR		VARCHAR(15);
DECLARE Var_ActividadBMXDesc	VARCHAR(200);
DECLARE Var_ActividadBMXDescR	VARCHAR(200);
DECLARE Var_Telefono			VARCHAR(45);
DECLARE Var_TelefonoCelular		VARCHAR(20);
DECLARE Var_TelefonoR			VARCHAR(45);
DECLARE Var_TelefonoCelularR	VARCHAR(20);
DECLARE Var_IngresoRealoRecur	VARCHAR(25);
DECLARE Var_Separador			VARCHAR(5);

-- Asignacion de Constantes
SET	Cadena_Vacia			:= '';	-- Cadena Vacia
SET	Fecha_Vacia				:= '1900-01-01';-- Fecha Vacia
SET	Entero_Cero				:= 0;	-- Entero Cero
SET	Decimal_Cero			:= 0.0;	-- DECIMAL Cero
SET CuentaPrincipalSi 		:='S';	-- La cuenta de ahorro SI es la principal del cliente
SET TitularSi				:='S';	-- El relacionado a cuenta es Titular
SET ProvRecursosSi			:='S';	-- El relacionado a cuenta es Proveedor de Recursos
SET PropRealSi				:='S';	-- El relacionado a cuenta es Propietario REAL
SET DireccOfcialSi			:='S';	-- Si es direccion oficial del Cliente
SET ConstanteSI				:='S';	-- Si
SET ConstanteNO				:='N';	-- No
SET EstatusVigente			:='V';	-- Estatus de la relacion vigente
SET menosVeinteMil			:='Ing1';
SET veintemilCincuentamil	:='Ing2';
SET cincuentamilCienmil		:='Ing3';
SET mayorCienmil			:='Ing4';
SET RelVigente              := 'V';

SET Var_IngresoRealoRecur := Cadena_Vacia;

-- Se obtiene el numero de cuenta de ahorro y el numero del cliente
SELECT CuentaAhoID, 	ClienteID
INTO Var_CuentaAhoID,	Var_ClienteID
	FROM CUENTASAHO
		WHERE CuentaAhoID = Par_CuentaAhoID;

-- Se obtiene el ingreso aproximado mensual del cliente
SELECT CASE WHEN IngAproxMes=menosVeinteMil			THEN 'Menos de $20,000.00'
			WHEN IngAproxMes=veintemilCincuentamil	THEN '$20,001.00 a $50,000.00'
			WHEN IngAproxMes=cincuentamilCienmil	THEN '$50,001.00 a $100,000.00'
			WHEN IngAproxMes=mayorCienmil			THEN 'Mayor a $100,000.00' END
INTO Var_IngresoRealoRecur
	FROM CONOCIMIENTOCTE
		WHERE ClienteID = IFNULL(Var_ClienteID,Entero_Cero);

-- se obtiene la direccion oficial del cliente
SELECT UPPER(DireccionCompleta) INTO Var_DirecCompleta
	FROM  DIRECCLIENTE
		WHERE ClienteID = IFNULL(Var_ClienteID,Entero_Cero)
			AND Oficial = DireccOfcialSi;

-- se obtiene los datos del cliente
SELECT
        CONCAT(IFNULL(PrimerNombre,''), ' ',IFNULL(SegundoNombre,''), ' ',IFNULL(TercerNombre,'')) AS Nombres,	ApellidoPaterno,	ApellidoMaterno,
		NombreCompleto, 	CURP, 				RFC, 							FEA,				ActividadBancoMX,
        Telefono,			TelefonoCelular
INTO
		Var_Nombres,		Var_ApellidoPaterno,		Var_ApellidoMaterno,
        Var_NombreCompleto,	Var_CURP,			Var_RFC,						Var_FEA,			Var_ActividadBMX,
        Var_Telefono, 		Var_TelefonoCelular
        FROM CLIENTES
			WHERE ClienteID = IFNULL(Var_ClienteID,Entero_Cero);

-- se concatenan los telefonos para mostrarlos en uno solo
IF(IFNULL(Var_Telefono,Cadena_Vacia)!=Cadena_Vacia) THEN
	SET Var_Telefono := CONCAT(IFNULL(Var_Telefono,Cadena_Vacia),', ',IFNULL(Var_TelefonoCelular,Cadena_Vacia));
ELSE
	SET Var_Telefono := CONCAT(IFNULL(Var_TelefonoCelular,Cadena_Vacia));
END IF;

-- se obtiene la descripcion de la actividad BMX del Cliente
SELECT	Descripcion INTO Var_ActividadBMXDesc
	FROM ACTIVIDADESBMX
		WHERE  ActividadBMXID = Var_ActividadBMX;

-- SE CONFIRMA LA EXISTENCIA DE PERSONAS RELACIONADAS A LA CUENTA
IF EXISTS (SELECT CuentaAhoID
			FROM CUENTASPERSONA
				WHERE CuentaAhoID = Par_CuentaAhoID
					AND EstatusRelacion = EstatusVigente AND
					(EsProvRecurso = ProvRecursosSi OR EsPropReal = PropRealSi))THEN

	-- se obtiene la actividad BMX y los telefonos de la persona relacionada
    SELECT ActividadBancoMX, TelefonoCasa, TelefonoCelular
    INTO Var_ActividadBMXR, Var_TelefonoR, Var_TelefonoCelularR
			FROM CUENTASPERSONA
				WHERE CuentaAhoID = Par_CuentaAhoID AND
					(EsProvRecurso = ProvRecursosSi
					OR EsPropReal = PropRealSi) LIMIT 1;

	-- se obtiene la descripcion de la actividad BMX de la persona relacionada
	SELECT	Descripcion INTO Var_ActividadBMXDescR
		FROM ACTIVIDADESBMX
			WHERE  ActividadBMXID = Var_ActividadBMXR;

	-- se concatenan los telefonos para mostrarlos en uno solo
	IF(IFNULL(Var_TelefonoR,Cadena_Vacia)!=Cadena_Vacia) THEN
		SET Var_TelefonoR := CONCAT(IFNULL(Var_TelefonoR,Cadena_Vacia),', ',IFNULL(Var_TelefonoCelularR,Cadena_Vacia));
	ELSE
		SET Var_TelefonoR := CONCAT(IFNULL(Var_TelefonoCelularR,Cadena_Vacia));
	END IF;

	-- se hace la consulta para el reporte
	SELECT
		Var_Nombres,			Var_ApellidoPaterno,	Var_ApellidoMaterno,        Var_NombreCompleto,	Var_CURP,
        Var_RFC,				Var_FEA,				Var_ActividadBMXDesc,       Var_DirecCompleta,	Var_Telefono,
        Var_TelefonoCelular,	Var_IngresoRealoRecur,

        IFNULL(EsProvRecurso,ConstanteNO)EsProvRecurso,							IFNULL(EsPropReal,ConstanteNO)EsPropReal,
        CONCAT(PrimerNombre, ' ',SegundoNombre, ' ',TercerNombre) AS Nombres, 	ApellidoPaterno,
        ApellidoMaterno,				NombreCompleto,
        CURP, 							RFC,
        FEA,							Var_ActividadBMXDescR AS ActividadBancoMX,
        UPPER(Domicilio)Domicilio, 		Var_TelefonoR AS Telefono,
        TelefonoCelular,				IngresoRealoRecur
			FROM CUENTASPERSONA
				WHERE CuentaAhoID = Par_CuentaAhoID AND
					(EsProvRecurso = ProvRecursosSi
					OR EsPropReal = PropRealSi)
					AND EstatusRelacion = RelVigente LIMIT 1;

ELSE
	-- si no existe algun relacionado a la cuenta, solo se toman los datos del cliente
	SELECT
        Var_Nombres,			Var_ApellidoPaterno,	Var_ApellidoMaterno,        Var_NombreCompleto,	Var_CURP,
        Var_RFC,				Var_FEA,				Var_ActividadBMXDesc,       Var_DirecCompleta, 	Var_Telefono,
        Var_TelefonoCelular, 	Var_IngresoRealoRecur,

		Cadena_Vacia AS EsProvRecurso, 	Cadena_Vacia AS EsPropReal,
        Cadena_Vacia AS Nombres, 		Cadena_Vacia AS ApellidoPaterno,
        Cadena_Vacia AS ApellidoMaterno,Cadena_Vacia AS NombreCompleto,
        Cadena_Vacia AS CURP,			Cadena_Vacia AS RFC,
        Cadena_Vacia AS FEA, 			Cadena_Vacia AS ActividadBancoMX,
        Cadena_Vacia AS Domicilio, 		Cadena_Vacia AS Telefono,
        Cadena_Vacia AS TelefonoCelular,Cadena_Vacia AS IngresoRealoRecur;
END IF;
-- FIN EXISTENCIA DE PERSONAS RELACIONADAS A LA CUENTA

END TerminaStore$$