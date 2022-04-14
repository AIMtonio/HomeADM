-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAPRINCIPALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAPRINCIPALPRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAPRINCIPALPRO`(
	-- SP que genera informacion del Estado Cuenta
	Par_AnioMes					INT(11),		-- Anio y Mes Estado Cuenta
	-- Parametros de Auditoria
	Par_EmpresaID				INT,			-- Parametro de Auditoria
	Aud_Usuario					INT,			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				INT,			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT			-- Parametro de Auditoria

)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_FecIniMes			DATE;			-- Fecha de Fin de mes
DECLARE Var_FecFinMes			DATE;			-- Fecha de Fin de mes
DECLARE Var_NumSucursal			INT(11);		-- Numero de Sucursal
-- Edicion de tamaño de variable Var_AnioMesStr. Cardinal Sistemas Inteligentes
DECLARE Var_AnioMesStr			VARCHAR(10);	-- Anio y Mes en formato cadena
-- Declaracion de variables. Cardinal Sistemas Inteligentes
DECLARE Var_NumErr				INT(11);		-- Variable para el numero de error
DECLARE Var_ErrMen				VARCHAR(400);	-- Variable para el mensaje de error
DECLARE Var_Status				CHAR(1);		-- Estatus
DECLARE Var_Anio				INT(11);		-- Anio
DECLARE Var_MesIni				INT(11);		-- Mes Inicio
DECLARE Var_MesFin				INT(11);		-- Mes Fin
DECLARE Var_Tipo				CHAR(1);		-- Tipo de generacion
DECLARE Var_NumPerEjecutado		INT(11);		-- Numero de periodos en los que se ha ejecutado la generacion de estado de cuenta
DECLARE Var_TotalClientes		INT(11);		-- Numero total de clientes
DECLARE Var_NumCliPDFGenera		INT(11);		-- Numero de clientes cuyo PDF se ha generado
DECLARE Var_AnioMesFinSem		INT(11);		-- Anio y Mes final del semestre

-- Declaracion de Constantes
DECLARE DiaUnoDelMes			CHAR(2);		-- Dia Primero del mes
DECLARE Var_ClienteInstitu		INT(11);		-- Identificador del cliente que representa la institucion
-- Declaracion de constantes. Cardinal Sistemas Inteligentes
DECLARE Entero_Cero				INT(11);		-- Entero cero
DECLARE	Var_ActualizaCorreo		CHAR(1);		-- Indica que si se debe actualizar el correo
DECLARE Cadena_Vacia			VARCHAR(1);		-- Cadena Vacia
DECLARE Fecha_Vacia				DATE;			-- Fecha Vacia
DECLARE Moneda_Cero				INT(11);		-- Moneda cero
DECLARE PDFGeneraSI				CHAR(1);		-- Bandera de generacion de estado de cuenta en formato PDF
DECLARE NumMesJunio				INT(11);		-- Numero que representa el mes de Junio
DECLARE NumMesDiciembre			INT(11);		-- Numero que representa el mes de Diciembre
DECLARE Entero_Uno				INT(11);		-- Entero uno
DECLARE Entero_Dos				INT(11);		-- Entero dos
DECLARE Entero_Cinco			INT(11);		-- Entero cinco
DECLARE Entero_Seis				INT(11);		-- Entero seis
DECLARE SalidaNO				CHAR(1);		-- Salida no
DECLARE SalidaSI				CHAR(1);		-- Salida si
DECLARE TipoGenMensual			CHAR(1);		-- Tipo de generacion de estado de cuenta mensual
DECLARE TipoGenSemestral		CHAR(1);		-- Tipo de generacion de estado de cuenta semestral

-- Asignacion de Constantes
SET DiaUnoDelMes			:= '01';			-- Asignacion de Dia Primero del mes
SET Var_ClienteInstitu		:= 1;				-- Asignacion de cliente que representa la institucion
-- Asignacion de constantes. Cardinal Sistemas Inteligentes
SET Entero_Cero				:= 0;				-- Asignacion de Entero cero
SET	Var_ActualizaCorreo		:= 'S';				-- Indica que si se debe actualizar el correo
SET Cadena_Vacia			:= '';				-- Asignacion de cadena vacia
SET Fecha_Vacia				:= '1900-01-01';	-- Asignacion de Fecha Vacia
SET Moneda_Cero				:= 0.00;			-- Asignacion de Moneda cero
SET PDFGeneraSI				:= 'S';				-- Asignacion de bandera de generacion de PDF
SET Entero_Uno				:= 1;				-- Asignacion de Entero uno
SET Entero_Dos				:= 2;				-- Asignacion de Entero dos
SET Entero_Cinco			:= 5;				-- Asignacion de Entero cinco
SET Entero_Seis				:= 6;				-- Asignacion de Entero seis
SET NumMesJunio				:= 6;				-- Asignacion de numero que representa el mes de Junio
SET NumMesDiciembre			:= 12;				-- Asignacion de numero que representa el mes de Diciembre
SET SalidaNO				:= 'N';				-- Asignacion de salida no
SET SalidaSI				:= 'S';				-- Asignacion de salida si
SET TipoGenMensual			:= 'M';				-- Tipo de generacion de estado de cuenta mensual
SET TipoGenSemestral		:= 'S';				-- Tipo de generacion de estado de cuenta semestral

-- Asignacion de Variables
SET Var_NumSucursal			:= Aud_Sucursal;	-- Asignacion de numero de sucursal
-- Asignacion de Variables. Cardinal Sistemas Inteligentes
SET Var_AnioMesStr			:= CAST(Par_AnioMes AS CHAR);

IF (CHAR_LENGTH(Var_AnioMesStr) > Entero_Seis) THEN
	SET Var_FecIniMes := DATE(CONCAT(LEFT(Var_AnioMesStr, Entero_Seis),DiaUnoDelMes));
	SET Var_Anio := YEAR(Var_FecIniMes);
	SET Var_MesIni := MONTH(Var_FecIniMes);
	SET Var_FecFinMes := DATE_ADD(Var_FecIniMes,INTERVAL Entero_Seis MONTH);
	SET Var_FecFinMes := DATE_ADD(Var_FecFinMes,INTERVAL -Entero_Uno DAY);
	SET Var_MesFin := MONTH(Var_FecFinMes);
	SET Var_Tipo := TipoGenSemestral;
ELSE
	SET Var_FecIniMes := DATE(CONCAT(Var_AnioMesStr,DiaUnoDelMes));
	SET Var_Anio := YEAR(Var_FecIniMes);
	SET Var_MesIni := MONTH(Var_FecIniMes);
	SET Var_MesFin := Var_MesIni;
	SET Var_Tipo := TipoGenMensual;
	-- Se obtiente la fecha inicial del mes siguiente
	SET Var_FecFinMes := DATE_ADD(Var_FecIniMes,INTERVAL Entero_Uno MONTH);

	-- Se obtiene la fecha final para generar informacion del estado de cuenta mensual
	SET Var_FecFinMes := DATE_ADD(Var_FecFinMes,INTERVAL -Entero_Uno DAY);
END IF;

ManejoErrores:BEGIN
	-- Verifica si el Periodo de estado de cuenta a ejecutar ya se ha ejecutado previamente
	SELECT	COUNT(*)
		INTO Var_NumPerEjecutado
		FROM EDOCTAPERMENEJECUTADOS
		WHERE Anio = Var_Anio
		  AND MesInicio = Var_MesIni
		  AND MesFin = Var_MesFin
		  AND Tipo = Var_Tipo;

	IF(Var_NumPerEjecutado > Entero_Cero) THEN
		SET Var_NumErr := 001;
		SET Var_ErrMen := 'Ya se encuentra generado el estado de cuenta del rango ingresado';
			LEAVE ManejoErrores;
	END IF;

	IF(Var_Tipo = TipoGenSemestral) THEN
		SET Var_AnioMesStr := CONCAT(Var_Anio, LPAD(Var_MesFin, Entero_Dos,'0'));
		SET Var_AnioMesFinSem := CAST(Var_AnioMesStr AS SIGNED);
		SELECT COUNT(ClienteID) INTO Var_TotalClientes FROM EDOCTAENVIOCORREO WHERE AnioMes = Var_AnioMesFinSem;
		SELECT COUNT(ClienteID) INTO Var_NumCliPDFGenera FROM EDOCTAENVIOCORREO WHERE AnioMes = Var_AnioMesFinSem AND PDFGenerado = PDFGeneraSI;

		IF (Var_TotalClientes != Var_NumCliPDFGenera) THEN
			SET Var_NumErr := 002;
			SET Var_ErrMen := 'No se ha generado el PDF de Estado de Cuenta de todos los clientes en el ultimo mes del semestre';
			LEAVE ManejoErrores;
		END IF;
	END IF;


TRUNCATE TABLE EDOCTADATOSCTE;
TRUNCATE TABLE EDOCTARESUMCTA;
TRUNCATE TABLE EDOCTADETACTA;
TRUNCATE TABLE EDOCTADETACTACOM;
TRUNCATE TABLE EDOCTAHEADERINV;
TRUNCATE TABLE EDOCTARESUM015INV;
TRUNCATE TABLE EDOCTARESUM024INV;
TRUNCATE TABLE EDOCTARESUMINV;
TRUNCATE TABLE EDOCTACOBROIDE;
TRUNCATE TABLE EDOCTARESUMCREDITOS;
TRUNCATE TABLE EDOCTARESUMCREDITOSCOM;
TRUNCATE TABLE EDOCTAHEADERDETCRE;
TRUNCATE TABLE EDOCTADETCRE;
TRUNCATE TABLE EDOCTAGRAFICA;
TRUNCATE TABLE CONELECDETACRE;
TRUNCATE TABLE EDOCTADATOSCTECOM;
TRUNCATE TABLE EDOCTARESUMCTACOM;
TRUNCATE TABLE EDOCTADETINVER;
TRUNCATE TABLE EDOCTAHEADER099INV;
TRUNCATE TABLE EDOCTAHEADERCRED;
TRUNCATE TABLE EDOCTAHEADERCTA;
TRUNCATE TABLE EDOCTARESUM099CREDITOS;
TRUNCATE TABLE EDOCTACFDIDATOS;

-- Datos del Cliente
 CALL EDOCTADATOSCTEPRO(Par_AnioMes, Var_FecIniMes, Var_FecFinMes, Var_ClienteInstitu);
-- Resumen de Cuenta
 CALL EDOCTARESUMCTAPRO(Par_AnioMes, Var_NumSucursal, Var_FecIniMes, Var_FecFinMes, Var_ClienteInstitu);
-- Header de Resumen de la Cuenta
 CALL EDOCTAHEADERCTAPRO(Par_AnioMes, Var_NumSucursal, Var_FecIniMes, Var_FecFinMes);
-- Detalle del estado de cuenta
 CALL EDOCTADETACTAPRO(Par_AnioMes, Var_NumSucursal, Var_FecIniMes, Var_FecFinMes, Var_ClienteInstitu);
-- Suma de Inversiones
 CALL EDOCTARESUMINVPRO(Par_AnioMes, Var_NumSucursal, Var_FecIniMes, Var_FecFinMes );
-- Header de Resumen de Inversiones
CALL EDOCTAHEADERINVPRO (Par_AnioMes, Var_FecIniMes, Var_FecFinMes);
-- Detalle de Inversiones
CALL EDOCTADETINVERPRO (Par_AnioMes, Var_FecIniMes, Var_FecFinMes);
-- Suma de Creditos
 CALL EDOCTARESUMCREDITOSPRO(Par_AnioMes, Var_NumSucursal, Var_FecIniMes, Var_FecFinMes);
 -- Encabezado de Creditos
 CALL EDOCTAHEADERCREDPRO(Par_AnioMes, Var_FecIniMes, Var_FecFinMes);
-- Detalle de Creditos
 CALL EDOCTADETCREPRO(Par_AnioMes, Var_NumSucursal, Var_FecIniMes, Var_FecFinMes);
-- Estado de Cuenta Graficas
 CALL EDOCTAGRAFICAPRO(Par_AnioMes, Var_NumSucursal, Var_FecIniMes, Var_FecFinMes);
 -- Datos para generar cadenas CFDI
 CALL EDOCTACFDIDATOSPRO(Par_AnioMes, Var_NumSucursal, Var_FecIniMes, Var_FecFinMes, Var_ClienteInstitu);
	-- Se agrega un proceso para llenar la tabla EDOCTAENVIOCORREO. Cardinal Sistemas Inteligentes
	CALL EDOCTAENVIOCORREOPRO(	Par_AnioMes,	Var_ActualizaCorreo,	SalidaSI,			Var_NumErr,			Var_ErrMen,
								Par_EmpresaID,	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
								Aud_Sucursal,	Aud_NumTransaccion);
	-- Fin de proceso para EDOCTAENVIOCORREO. Cardinal Sistemas Inteligentes

	CALL EDOCTAPERMENEJECUTADOSALT(	Var_Anio,			Var_MesIni,				Var_MesFin,			Var_Tipo,			SalidaSI,
									Var_NumErr,			Var_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
									Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
									
	-- HISTORICO DE LOS DATOS DEL CLIENTE
	CALL EDOCTAHISCDATOSCTEALT(	Var_Anio,			Var_MesIni,				Var_MesFin,			Var_Tipo,			SalidaSI,
								Var_NumErr,			Var_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
								Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

    -- ALTA DE COONTROL DE LOS PRODUCTOS TIMBRADOS
    CALL EDOCTAESTATUSTIMPRODALT(Var_Anio,			Var_MesIni,				Var_MesFin,			Var_Tipo,			SalidaSI,
								Var_NumErr,			Var_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
								Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
                               
END ManejoErrores;
	IF (Var_Tipo = TipoGenSemestral) THEN
		IF (Var_NumErr <> Entero_Cero) THEN
		SELECT  Var_NumErr AS NumErr,
				Var_ErrMen AS ErrMen;
		LEAVE TerminaStore;
		END IF;
		-- Actualizar el campo MesProceso de EDOCTAPARAMS para el semestre
		UPDATE EDOCTAPARAMS
		SET MesProceso = Par_AnioMes;

		SELECT  000 AS NumErr,
				'Generacion de Información de Estado de Cuenta realizada exitosamente' AS ErrMen;
	END IF;
END TerminaStore$$