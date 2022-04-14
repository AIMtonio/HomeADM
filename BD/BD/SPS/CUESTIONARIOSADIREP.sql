-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUESTIONARIOSADIREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUESTIONARIOSADIREP`;DELIMITER $$

CREATE PROCEDURE `CUESTIONARIOSADIREP`(
	/******************************************************************************************
							SP PARA EL REPORTE DE CUESTIONARIOS ADICIONALES
	******************************************************************************************/
	Par_ClienteID			INT(11),			-- ID del cliente
	Par_TipoPersona			CHAR(1),			-- Tipo de Persona F: Fisica, M: Moral
	Par_SucursalID			INT(11),			-- ID de la Sucursal
	Par_SeccionReporte		TINYINT,			-- Seccion del reporte a mostrar

	Aud_EmpresaID			INT(11),			-- Parametro de Audiroria
	Aud_Usuario     		INT(11),      		-- Parametro de Audiroria
	Aud_FechaActual   		DATETIME,     		-- Parametro de Audiroria
	Aud_DireccionIP   		VARCHAR(15),    	-- Parametro de Audiroria
	Aud_ProgramaID    		VARCHAR(50),    	-- Parametro de Audiroria
	Aud_Sucursal    		INT(11),      		-- Parametro de Audiroria
	Aud_NumTransaccion  	BIGINT(20)      	-- Parametro de Audiroria
	)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES

DECLARE Var_SucursalNombre			VARCHAR(50);	-- Nombre de la Sucursal
DECLARE Var_LugarSucursal			VARCHAR(200);	-- Municipio y estado de la sucursal
DECLARE Var_FechaSistema			VARCHAR(70);	-- Fecha Sistema

DECLARE Var_NombreCompleto			VARCHAR(200);	-- Nombre completo del cliente
DECLARE Var_Nacion 					VARCHAR(20);	-- Nacionalidad del cliente
DECLARE Var_Telefono 				VARCHAR(20);	-- Telefono cel Cliente
DECLARE Var_TelefonoCelular 		VARCHAR(20);	-- Telefono Celular del cliente
DECLARE Var_TelTrabajo 				VARCHAR(20);	-- Telefono del trabajo del cliente
DECLARE Var_DireccionCompleta		VARCHAR(500);	-- Direccion Completa del cliente
DECLARE Var_EstadoCivil				CHAR(2);		-- Estado civil del cliente
DECLARE Var_Ocupacion				TEXT;			-- Ocupacion del cliente
DECLARE Var_DomicilioTrabajo		VARCHAR(500);	-- Domicilio del trabajo del cliente
DECLARE Var_ClienteConyugeID		INT(11);		-- ID del conyuge del cliente si tambien es cliente
DECLARE Var_ConyNombreCompleto		VARCHAR(200);	-- Nombre Completo del Conyuge
DECLARE Var_ConyNacion 				VARCHAR(20);	-- Nacionalidad del Conyuge
DECLARE Var_ConyTelefono 			VARCHAR(20);	-- Telefono del Conyuge
DECLARE Var_ConyTelefonoCelular 	VARCHAR(20);	-- Telefono Celular del Conyuge
DECLARE Var_ConyTelTrabajo 			VARCHAR(20);	-- Telefono del trabajo del Conyuge
DECLARE Var_ConyDireccionCompleta	VARCHAR(500);	-- Direccion completa del Conyuge
DECLARE Var_ConyPrimerNombre		VARCHAR(50);	-- Primer nombre del Conyuge
DECLARE Var_ConySegundoNombre		VARCHAR(50);	-- Segundo nombre del Conyuge
DECLARE Var_ConyTercerNombre		VARCHAR(50);	-- Tercer Nombre del Conyuge
DECLARE Var_ConyApellidoPaterno		VARCHAR(50);	-- Apellido Paterno del Conyuge
DECLARE Var_ConyApellidoMaterno		VARCHAR(50);	-- Apellido Materno del Conyuge
DECLARE Var_IngresosMensuales		VARCHAR(30);	-- Monto de los ingresos mensuales
DECLARE Var_OtrosIngresosMensuales	DECIMAL(14,2);	-- Otros Ingresos
DECLARE Var_OrigenRecursos			VARCHAR(100);	-- Origen de los recursos
DECLARE Var_DestinoRecursos			VARCHAR(100);	-- Destino de los recursos
DECLARE Var_PEP 					CHAR(1);		-- Persona Politicamente Expuesta S: Si, N: No
DECLARE Var_NombrePapa				VARCHAR(200);	-- Nombre del padre
DECLARE Var_NombreMama				VARCHAR(200);	-- Nombre de la madre
DECLARE Var_NombreHermanoUNO		VARCHAR(200);	-- Nombre del hermano
DECLARE Var_NombreHermanoDOS		VARCHAR(200);	-- Nombre del hermano
DECLARE Var_CargoPEP				VARCHAR(150);	-- Funcion Publica en caso de PEPs
DECLARE Var_FechaNombramiento		DATE;			-- Fecha de Nombramiento en caso de PEPs
DECLARE Var_PeriodoCargo 			VARCHAR(100);	-- Periodo del Cargo
DECLARE Var_VinculoAsociacion		CHAR(1);		-- Tiene Vinculos con otras sociedades o asociaciones
DECLARE Var_NombreVinculo			VARCHAR(150);	-- Nombre de la sociedad o asociacion con la que se tiene el vinculo
DECLARE Var_PorcentajeAcciones		DECIMAL(12,2);	-- Porcentaje de las Acciones
DECLARE Var_MontoAcciones			DECIMAL(12,2);	-- Monto de las Acciones
DECLARE Var_NombreDependenUNO		VARCHAR(200);		-- Nombre del dependiente economico
DECLARE Var_ParentescoDependenUNO 	VARCHAR(50);		-- Parentesco del dependiente economico
DECLARE Var_NacionDependenUNO 		VARCHAR(20);		-- Nacionalidad del dependiente economico
DECLARE Var_DomicilioDependenUNO 	VARCHAR(500);		-- Domicilio del dependiente economico
DECLARE Var_TelefonoDependenUNO		VARCHAR(20);		-- Telefono del dependiente economico
DECLARE Var_NombreDependenDOS		VARCHAR(200);		-- Nombre del dependiente economico
DECLARE Var_ParentescoDependenDOS 	VARCHAR(50);		-- Parentesco del dependiente economico
DECLARE Var_NacionDependenDOS 		VARCHAR(20);		-- Nacionalidad del dependiente economico
DECLARE Var_DomicilioDependenDOS 	VARCHAR(500);		-- Domicilio del dependiente economico
DECLARE Var_TelefonoDependenDOS		VARCHAR(20);		-- Telefono del dependiente economico
DECLARE Var_NombreDependenTRES		VARCHAR(200);		-- Nombre del dependiente economico
DECLARE Var_ParentescoDependenTRES 	VARCHAR(50);		-- Parentesco del dependiente economico
DECLARE Var_NacionDependenTRES 		VARCHAR(20);		-- Nacionalidad del dependiente economico
DECLARE Var_DomicilioDependenTRES 	VARCHAR(500);		-- Domicilio del dependiente economico
DECLARE Var_TelefonoDependenTRES	VARCHAR(20);		-- Telefono del dependiente economico
DECLARE Var_NombreDependenCUATRO	VARCHAR(200);		-- Nombre del dependiente economico
DECLARE Var_ParentescoDependenCUATRO VARCHAR(50);		-- Parentesco del dependiente economico
DECLARE Var_NacionDependenCUATRO 	VARCHAR(20);		-- Nacionalidad del dependiente economico
DECLARE Var_DomicilioDependenCUATRO VARCHAR(500);		-- Domicilio del dependiente economico
DECLARE Var_TelefonoDependenCUATRO	VARCHAR(20);		-- Telefono del dependiente economico
DECLARE Var_NombreSocVinculo		VARCHAR(150);		-- Nombre del Vinculo o Sociedad con la que se tiene relacion
DECLARE Var_PorcentajeVinculo		DECIMAL(12,4);		-- Nombre del Vinculo o Sociedad con la que se tiene relacion
DECLARE	Var_GiroMercantil			VARCHAR(100);		-- Giro de la empresa
DECLARE	Var_OrigenOtrosIngresos 	VARCHAR(100);		-- Origen de otros recursos
DECLARE	Var_DestinoOtrosIngresos 	VARCHAR(100);		-- Destino de otros recursos
DECLARE	Var_SectorEconomico 		VARCHAR(100);		-- Sector economico de la empresa
DECLARE	Var_PaisesOperacion 		VARCHAR(200);		-- Paises en los que opera
DECLARE	Var_EstadosCobertura		VARCHAR(50);		-- Estados (republica mexicana) de cobertura
DECLARE	Var_TiposClientes 			VARCHAR(20);		-- Tipos de Clientes PFs o PMs
DECLARE	Var_InstrumentosMonetarios	VARCHAR(20);		-- Instrumentos Monetarios (E)Efectivo, (C)Cheque, (T)Transferencia
DECLARE	Var_MontosAproxClientes		DECIMAL(14,2);		-- Montos aproximados por clientes
DECLARE	Var_ImportaExporta			CHAR(2);			-- Si/No Importa o Exporta
DECLARE Var_RepresentanteLegal		VARCHAR(150);		-- Nombre del representante legal de la Persona Moral


-- DECLARACION DE CONSTANTES
DECLARE Constante_SI			CHAR(1);		-- Constante SI
DECLARE Constante_NO			CHAR(1);		-- Constante NO
DECLARE Casado_CS				CHAR(2);		-- Casado por Bienes Separados
DECLARE Casado_CM				CHAR(2);		-- Casado por Bienes Mancomunados
DECLARE Casado_CC				CHAR(2);		-- Casado por Bienes Mancomunados con Capitulacion
DECLARE Entero_Cero				TINYINT;		-- Constante Entero Cero
DECLARE Decimal_Cero			DECIMAL(2,2);	-- Constante DECIMAL Cero
DECLARE	TipoDireccionTrabajo	TINYINT;		-- Direccion Tipo Trabajo
DECLARE Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
DECLARE Persona_Fisica			CHAR(1);		-- Tipo de persona Fisica
DECLARE Persona_Moral			CHAR(1);		-- Tipo de persona Moral
DECLARE Padre_Madre				TINYINT;		-- Tipo Relacion PADRE O MADRE
DECLARE Hermano 				TINYINT;		-- Tipo Relacion HERMANO(A)
DECLARE Datos_Generales			TINYINT;		-- Seccion Datos generales
DECLARE Vinculos_Sociedades		TINYINT;		-- Vinculos con otras sociedades
DECLARE OtrosIngresos 			TINYINT;		-- Hace referencia a la tabla de Catalogo de datos Socioeconomicos
DECLARE Str_SI					CHAR(2);		-- Constante String SI
DECLARE Str_NO					CHAR(2);		-- Constante String NO
DECLARE Nacionalidad_M			VARCHAR(15);	-- Conatante Nacionalidad Mexicana
DECLARE Nacionalidad_E			VARCHAR(15);	-- Conatante Nacionalidad Extranjera
DECLARE Constante_Ing1			VARCHAR(30);	-- Constante Ingreso 1
DECLARE Constante_Ing2			VARCHAR(30);	-- Constante Ingreso 2
DECLARE Constante_Ing3			VARCHAR(30);	-- Constante Ingreso 3
DECLARE Constante_Ing4			VARCHAR(30);	-- Constante Ingreso 4



-- ASIGNACION DE CONSTANTES
SET Constante_SI				:= 'S';
SET Constante_NO				:= 'N';
SET Casado_CS					:= 'CS';
SET Casado_CM					:= 'CM';
SET Casado_CC					:= 'CC';
SET Entero_Cero					:= 0;
SET Decimal_Cero				:= 00.00;
SET TipoDireccionTrabajo		:= 3;
SET Cadena_Vacia				:= '';
SET Persona_Fisica				:= 'F';
SET Persona_Moral				:= 'M';
SET Padre_Madre					:= 22;
SET Hermano 					:= 24;
SET Datos_Generales				:= 1;
SET Vinculos_Sociedades			:= 2;
SET OtrosIngresos 				:= 6;
SET Str_SI						:= 'SI';
SET Str_NO						:= 'NO';
SET Nacionalidad_M				:= 'MEXICANA';
SET Nacionalidad_E				:= 'EXTRANJERA';
SET Constante_Ing1				:= 'Menos de $20,000';
SET Constante_Ing2				:= 'De $20,001 a $50,000';
SET Constante_Ing3				:= 'De $50,001 a $100,000';
SET Constante_Ing4				:= 'Mayor a $100,000';



-- DATOS DE LA SUCURSAL
SELECT
	CONCAT(MUNI.Nombre, ', ', EST.Nombre),	SUC.NombreSucurs
INTO
	Var_LugarSucursal,						Var_SucursalNombre
FROM SUCURSALES SUC
INNER JOIN ESTADOSREPUB   EST       ON SUC.EstadoID = EST.EstadoID
INNER JOIN MUNICIPIOSREPUB  MUNI    ON SUC.EstadoID = MUNI.EstadoID     AND SUC.MunicipioID = MUNI.MunicipioID
INNER JOIN LOCALIDADREPUB   LOC     ON SUC.EstadoID = LOC.EstadoID      AND SUC.MunicipioID = LOC.MunicipioID   AND SUC.LocalidadID = LOC.LocalidadID
LEFT OUTER JOIN COLONIASREPUB COL   ON SUC.EstadoID = COL.EstadoID      AND SUC.MunicipioID = COL.MunicipioID   AND SUC.ColoniaID = COL.ColoniaID
WHERE SUC.SucursalID = Par_SucursalID;


SELECT FechaSistema
INTO Var_FechaSistema FROM PARAMETROSSIS;


-- ****************************************** INICIO SECCION PERSONA FISICA ******************************************
IF (Par_TipoPersona = Persona_Fisica) THEN

	-- DATOS DEL CLIENTE
	SELECT
		CLI.NombreCompleto, 		CLI.Nacion, 			CLI.Telefono, 			CLI.TelefonoCelular, 			CLI.TelTrabajo,
		DIR.DireccionCompleta,		CLI.EstadoCivil,		O.Descripcion,			DS.Monto
	INTO
		Var_NombreCompleto,			Var_Nacion,				Var_Telefono,			Var_TelefonoCelular,			Var_TelTrabajo,
		Var_DireccionCompleta,		Var_EstadoCivil,		Var_Ocupacion,			Var_OtrosIngresosMensuales
		FROM CLIENTES CLI
		LEFT JOIN DIRECCLIENTE DIR ON CLI.ClienteID = DIR.ClienteID AND DIR.Oficial = Constante_SI
	    LEFT JOIN OCUPACIONES O ON O.OcupacionID = CLI.OcupacionID
	    LEFT JOIN CLIDATSOCIOE DS ON DS.ClienteID = CLI.ClienteID AND DS.CatSocioEID = OtrosIngresos
	WHERE CLI.ClienteID = Par_ClienteID LIMIT 1 ;


	SET Var_Nacion := CASE
		WHEN (Var_Nacion = 'N') THEN Nacionalidad_M
		WHEN (Var_Nacion = 'E') THEN Nacionalidad_E
	END;


	--  INFORMACION DEL EMPLEO DEL CLIENTE
	SET Var_DomicilioTrabajo = (SELECT DireccionCompleta FROM DIRECCLIENTE WHERE ClienteID = Par_ClienteID AND TipoDireccionID = TipoDireccionTrabajo LIMIT 1);
	SET Var_DomicilioTrabajo = IFNULL(Var_DomicilioTrabajo, (SELECT DomicilioTrabajo FROM CLIENTES WHERE ClienteID = Par_ClienteID LIMIT 1));


	SELECT
		PFuenteIng, 				IngAproxMes,			PEPs
	INTO
		Var_OrigenRecursos,			Var_IngresosMensuales,	Var_PEP
FROM CONOCIMIENTOCTE WHERE ClienteID = Par_ClienteID LIMIT 1;


SET Var_IngresosMensuales := CASE
	WHEN (Var_IngresosMensuales = 'Ing1') THEN Constante_Ing1
	WHEN (Var_IngresosMensuales = 'Ing2') THEN Constante_Ing2
	WHEN (Var_IngresosMensuales = 'Ing3') THEN Constante_Ing3
	WHEN (Var_IngresosMensuales = 'Ing4') THEN Constante_Ing4
	ELSE Cadena_Vacia
END;


	--  DATOS DEL CONYUGE
	IF(Var_EstadoCivil = Casado_CS OR Var_EstadoCivil = Casado_CM OR Var_EstadoCivil = Casado_CC) THEN
		SET Var_ClienteConyugeID := (SELECT ClienteConyID FROM SOCIODEMOCONYUG WHERE ClienteID=Par_ClienteID);
		SET Var_ClienteConyugeID := IFNULL(Var_ClienteConyugeID, Entero_Cero);

		-- Si el Conyugue ES Cliente
		IF(Var_ClienteConyugeID != Entero_Cero) THEN
			SELECT
				CLI.NombreCompleto, 		CLI.Nacion, 		CLI.Telefono, 			CLI.TelefonoCelular, 			CLI.TelTrabajo,
				DIR.DireccionCompleta
			INTO
				Var_ConyNombreCompleto,		Var_ConyNacion,		Var_ConyTelefono,		Var_ConyTelefonoCelular,		Var_ConyTelTrabajo,
				Var_ConyDireccionCompleta
				FROM CLIENTES CLI
				INNER JOIN DIRECCLIENTE DIR ON CLI.ClienteID = DIR.ClienteID
			WHERE CLI.ClienteID = Var_ClienteConyugeID AND DIR.Oficial = Constante_SI;

		-- Si el Conyugue NO ES Cliente
		ELSE
			SELECT
				PrimerNombre, 			SegundoNombre, 			TercerNombre, 			ApellidoPaterno, 				ApellidoMaterno,
				Nacionalidad, 			TelCelular
			INTO
				Var_ConyPrimerNombre,	Var_ConySegundoNombre,	Var_ConyTercerNombre,	Var_ConyApellidoPaterno,		Var_ConyApellidoMaterno,
				Var_ConyNacion,			Var_ConyTelefonoCelular
			FROM SOCIODEMOCONYUG WHERE ClienteID = Par_ClienteID;
		END IF;

	END IF;


	SET Var_ConyNacion := CASE
		WHEN (Var_ConyNacion = 'N') THEN Nacionalidad_M
		WHEN (Var_ConyNacion = 'E') THEN Nacionalidad_E
	END;

	--  DATOS DEL LOS DEPENDIENTES DEL CLIENTE


	SELECT
		FNGENNOMBRECOMPLETO(SOC.PrimerNombre, SOC.SegundoNombre, SOC.TercerNombre,SOC.ApellidoPaterno, SOC.ApellidoMaterno),
		TPR.Descripcion
	INTO
		Var_NombreDependenUNO, Var_ParentescoDependenUNO
		FROM SOCIODEMODEPEND SOC
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = SOC.ClienteID
		INNER JOIN TIPORELACIONES TPR ON TPR.TipoRelacionID = SOC.TipoRelacionID
		WHERE CLI.ClienteID = Par_ClienteID LIMIT 0,1;

	SELECT
		FNGENNOMBRECOMPLETO(SOC.PrimerNombre, SOC.SegundoNombre, SOC.TercerNombre,SOC.ApellidoPaterno, SOC.ApellidoMaterno),
		TPR.Descripcion
	INTO
		Var_NombreDependenDOS, Var_ParentescoDependenDOS
	FROM SOCIODEMODEPEND SOC
	INNER JOIN CLIENTES CLI ON CLI.ClienteID = SOC.ClienteID
	INNER JOIN TIPORELACIONES TPR ON TPR.TipoRelacionID = SOC.TipoRelacionID
	WHERE CLI.ClienteID = Par_ClienteID LIMIT 1,1;

	SELECT
		FNGENNOMBRECOMPLETO(SOC.PrimerNombre, SOC.SegundoNombre, SOC.TercerNombre,SOC.ApellidoPaterno, SOC.ApellidoMaterno),
		TPR.Descripcion
	INTO
		Var_NombreDependenTRES, Var_ParentescoDependenTRES
	FROM SOCIODEMODEPEND SOC
	INNER JOIN CLIENTES CLI ON CLI.ClienteID = SOC.ClienteID
	INNER JOIN TIPORELACIONES TPR ON TPR.TipoRelacionID = SOC.TipoRelacionID
	WHERE CLI.ClienteID = Par_ClienteID LIMIT 2,1;

	SELECT
		FNGENNOMBRECOMPLETO(SOC.PrimerNombre, SOC.SegundoNombre, SOC.TercerNombre,SOC.ApellidoPaterno, SOC.ApellidoMaterno),
		TPR.Descripcion
	INTO
		Var_NombreDependenCUATRO, Var_ParentescoDependenCUATRO
	FROM SOCIODEMODEPEND SOC
	INNER JOIN CLIENTES CLI ON CLI.ClienteID = SOC.ClienteID
	INNER JOIN TIPORELACIONES TPR ON TPR.TipoRelacionID = SOC.TipoRelacionID
	WHERE CLI.ClienteID = Par_ClienteID LIMIT 3,1;


	-- SI ES PERSONA POLITICAMENTE EXPUESTA
	IF(Var_PEP = Constante_SI) THEN

		SELECT
			FUN.Descripcion,			CTE.FechaNombramiento, 			CTE.PeriodoCargo, 			CTE.PorcentajeAcciones,
			CTE.MontoAcciones
		INTO
			Var_CargoPEP,				Var_FechaNombramiento,			Var_PeriodoCargo,			Var_PorcentajeAcciones,
			Var_MontoAcciones
		FROM CONOCIMIENTOCTE CTE
		INNER JOIN FUNCIONESPUB FUN ON FUN.FuncionID = CTE.FuncionID
		WHERE CTE.ClienteID = Par_ClienteID LIMIT 1;


/******************************************************************************************
					SE DA PRIORIDAD A LA INFORMACIÓN DE LA TABLA RELACIONEMPLEADO
******************************************************************************************/
		SET Var_NombrePapa := (SELECT RE.NombreRelacionado
								FROM CLIENTES CLI
								INNER JOIN RELACIONPERSONAS RP ON CLI.RFC = RP.RFC AND CLI.CURP = RP.CURP
								INNER JOIN RELACIONEMPLEADO RE ON RP.PersonaID = RE.EmpleadoID
								WHERE CLI.ClienteID = Par_ClienteID AND RE.ParentescoID = Padre_Madre AND SUBSTRING(RE.CURP, 11, 1) = 'H');

		SET Var_NombreMama := (SELECT RE.NombreRelacionado
								FROM CLIENTES CLI
								INNER JOIN RELACIONPERSONAS RP ON CLI.RFC = RP.RFC AND CLI.CURP = RP.CURP
								INNER JOIN RELACIONEMPLEADO RE ON RP.PersonaID = RE.EmpleadoID
								WHERE CLI.ClienteID = Par_ClienteID AND RE.ParentescoID = Padre_Madre AND SUBSTRING(RE.CURP, 11, 1) = 'M');

		SET Var_NombreHermanoUNO := (SELECT RE.NombreRelacionado
								FROM CLIENTES CLI
								INNER JOIN RELACIONPERSONAS RP ON CLI.RFC = RP.RFC AND CLI.CURP = RP.CURP
								INNER JOIN RELACIONEMPLEADO RE ON RP.PersonaID = RE.EmpleadoID
								WHERE CLI.ClienteID = Par_ClienteID AND RE.ParentescoID = Hermano ORDER BY RE.RelacionEmpID ASC LIMIT 0,1);

		SET Var_NombreHermanoDOS := (SELECT RE.NombreRelacionado
								FROM CLIENTES CLI
								INNER JOIN RELACIONPERSONAS RP ON CLI.RFC = RP.RFC AND CLI.CURP = RP.CURP
								INNER JOIN RELACIONEMPLEADO RE ON RP.PersonaID = RE.EmpleadoID
								WHERE CLI.ClienteID = Par_ClienteID AND RE.ParentescoID = Hermano ORDER BY RE.RelacionEmpID ASC LIMIT 1,1);


	/********************************************************************************************************************
		Si no existiera información en la tabla RELACIONEMPLEADO, se toma la de la tabla CONOCIMIENTOCTE y se da por
		entendido que el primer Registro corresponde al Padre y el segundo a la Madre.
	*********************************************************************************************************************/

		IF(IFNULL(Var_NombrePapa, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Var_NombrePapa	:= (SELECT NombreRef FROM CONOCIMIENTOCTE WHERE ClienteID = Par_ClienteID AND TipoRelacion1 = Padre_Madre);
		END IF;

		IF(IFNULL(Var_NombreMama, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Var_NombreMama	:= (SELECT NombreRef2 FROM CONOCIMIENTOCTE WHERE ClienteID = Par_ClienteID AND TipoRelacion2 = Padre_Madre);
		END IF;

		IF(IFNULL(Var_NombreHermanoUNO, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Var_NombreHermanoUNO	:= (SELECT NombreRef FROM CONOCIMIENTOCTE WHERE ClienteID = Par_ClienteID AND TipoRelacion1 = Hermano);
		END IF;

		IF(IFNULL(Var_NombreHermanoDOS, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Var_NombreHermanoDOS	:= (SELECT NombreRef2 FROM CONOCIMIENTOCTE WHERE ClienteID = Par_ClienteID AND TipoRelacion2 = Hermano);
		END IF;


	/********************************************************************************************************************
		Si no existiera información en la tabla CONOCIMIENTOCTE, se toma la de la tabla SOCIODEMODEPEND y se da por
		entendido que el primer Registro corresponde al Padre y el segundo a la Madre.
	*********************************************************************************************************************/

		IF(IFNULL(Var_NombrePapa, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Var_NombrePapa	:= (SELECT FNGENNOMBRECOMPLETO(SOC.PrimerNombre, SOC.SegundoNombre, SOC.TercerNombre,SOC.ApellidoPaterno, SOC.ApellidoMaterno)
									FROM SOCIODEMODEPEND SOC
									INNER JOIN CLIENTES CLI ON CLI.ClienteID = SOC.ClienteID
									WHERE CLI.ClienteID = Par_ClienteID AND SOC.TipoRelacionID = Padre_Madre LIMIT 0,1);
		END IF;

		IF(IFNULL(Var_NombreMama, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Var_NombreMama	:= (SELECT FNGENNOMBRECOMPLETO(SOC.PrimerNombre, SOC.SegundoNombre, SOC.TercerNombre,SOC.ApellidoPaterno, SOC.ApellidoMaterno)
									FROM SOCIODEMODEPEND SOC
									INNER JOIN CLIENTES CLI ON CLI.ClienteID = SOC.ClienteID
									WHERE CLI.ClienteID = Par_ClienteID AND SOC.TipoRelacionID = Padre_Madre LIMIT 1,1);
		END IF;

		IF(IFNULL(Var_NombreHermanoUNO, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Var_NombreHermanoUNO	:= (SELECT FNGENNOMBRECOMPLETO(SOC.PrimerNombre, SOC.SegundoNombre, SOC.TercerNombre,SOC.ApellidoPaterno, SOC.ApellidoMaterno)
									FROM SOCIODEMODEPEND SOC
									INNER JOIN CLIENTES CLI ON CLI.ClienteID = SOC.ClienteID
									WHERE CLI.ClienteID = Par_ClienteID AND SOC.TipoRelacionID = Hermano LIMIT 0,1);
		END IF;

		IF(IFNULL(Var_NombreHermanoDOS, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Var_NombreHermanoDOS	:= (SELECT FNGENNOMBRECOMPLETO(SOC.PrimerNombre, SOC.SegundoNombre, SOC.TercerNombre,SOC.ApellidoPaterno, SOC.ApellidoMaterno)
									FROM SOCIODEMODEPEND SOC
									INNER JOIN CLIENTES CLI ON CLI.ClienteID = SOC.ClienteID
									WHERE CLI.ClienteID = Par_ClienteID AND SOC.TipoRelacionID = Hermano LIMIT 1,1);
		END IF;




	END IF;

	IF(Par_SeccionReporte = Datos_Generales) THEN
	SELECT
			IFNULL(Var_NombreCompleto, Cadena_Vacia) AS Var_NombreCompleto,
			IFNULL(Var_Nacion, Cadena_Vacia) AS Var_Nacion,
			IF(IFNULL(Var_Telefono, Cadena_Vacia) = Cadena_Vacia, Var_TelefonoCelular, Var_Telefono) AS Var_Telefono,
			IFNULL(Var_TelTrabajo, Cadena_Vacia) AS Var_TelTrabajo,
			IFNULL(Var_DireccionCompleta, Cadena_Vacia) AS Var_DireccionCompleta,

			IFNULL(Var_EstadoCivil, Cadena_Vacia) AS Var_EstadoCivil,
			IFNULL(Var_Ocupacion, Cadena_Vacia) AS Var_Ocupacion,
			IFNULL(Var_DomicilioTrabajo, Cadena_Vacia) AS Var_DomicilioTrabajo,
			IFNULL(Var_ClienteConyugeID, Cadena_Vacia) AS Var_ClienteConyugeID,
			IFNULL(Var_ConyNombreCompleto, Cadena_Vacia) AS Var_ConyNombreCompleto,

			IFNULL(Var_ConyNacion, Cadena_Vacia) AS Var_ConyNacion,
			IF(IFNULL(Var_ConyTelefono, Cadena_Vacia) = Cadena_Vacia, Var_ConyTelefonoCelular, Var_ConyTelefono) AS Var_ConyTelefono,
			IFNULL(Var_ConyTelTrabajo, Cadena_Vacia) AS Var_ConyTelTrabajo,
			IFNULL(Var_ConyDireccionCompleta, Cadena_Vacia) AS Var_ConyDireccionCompleta,
			IFNULL(Var_ConyPrimerNombre, Cadena_Vacia) AS Var_ConyPrimerNombre,

			IFNULL(Var_ConySegundoNombre, Cadena_Vacia) AS Var_ConySegundoNombre,
			IFNULL(Var_ConyTercerNombre, Cadena_Vacia) AS Var_ConyTercerNombre,
			IFNULL(Var_ConyApellidoPaterno, Cadena_Vacia) AS Var_ConyApellidoPaterno,
			IFNULL(Var_ConyApellidoMaterno, Cadena_Vacia) AS Var_ConyApellidoMaterno,
			IFNULL(Var_IngresosMensuales, CONCAT('$',Decimal_Cero)) AS Var_IngresosMensuales,

			CONCAT('$',IFNULL(Var_OtrosIngresosMensuales, Decimal_Cero)) AS Var_OtrosIngresosMensuales,
			IFNULL(Var_OrigenRecursos, Cadena_Vacia) AS Var_OrigenRecursos,
			IFNULL(Var_DestinoRecursos, Cadena_Vacia) AS Var_DestinoRecursos,
			IFNULL(Var_NombrePapa, Cadena_Vacia) AS Var_NombrePapa,
			IFNULL(Var_NombreMama, Cadena_Vacia) AS Var_NombreMama,

			IFNULL(Var_NombreHermanoUNO, Cadena_Vacia) AS Var_NombreHermanoUNO,
			IFNULL(Var_NombreHermanoDOS, Cadena_Vacia) AS Var_NombreHermanoDOS,
			IFNULL(Var_CargoPEP, Cadena_Vacia) AS Var_CargoPEP,
			IFNULL(Var_FechaNombramiento, Cadena_Vacia) AS Var_FechaNombramiento,
			IFNULL(Var_PeriodoCargo, Cadena_Vacia) AS Var_PeriodoCargo,

			IFNULL(Var_VinculoAsociacion, Cadena_Vacia) AS Var_VinculoAsociacion,
			IFNULL(Var_NombreVinculo, Cadena_Vacia) AS Var_NombreVinculo,
			CONCAT(IFNULL(Var_PorcentajeAcciones, Decimal_Cero), '%') AS Var_PorcentajeAcciones,
			CONCAT('$',IFNULL(Var_MontoAcciones, Decimal_Cero)) AS Var_MontoAcciones,

			IFNULL(Var_NombreDependenUNO, Cadena_Vacia) AS Var_NombreDependenUNO,
			IFNULL(Var_ParentescoDependenUNO, Cadena_Vacia) AS Var_ParentescoDependenUNO,
			IFNULL(Var_NacionDependenUNO, Cadena_Vacia) AS Var_NacionDependenUNO,
			IFNULL(Var_DomicilioDependenUNO, Cadena_Vacia) AS Var_DomicilioDependenUNO,
			IFNULL(Var_TelefonoDependenUNO, Cadena_Vacia) AS Var_TelefonoDependenUNO,

			IFNULL(Var_NombreDependenDOS, Cadena_Vacia) AS Var_NombreDependenDOS,
			IFNULL(Var_ParentescoDependenDOS, Cadena_Vacia) AS Var_ParentescoDependenDOS,
			IFNULL(Var_NacionDependenDOS, Cadena_Vacia) AS Var_NacionDependenDOS,
			IFNULL(Var_DomicilioDependenDOS, Cadena_Vacia) AS Var_DomicilioDependenDOS,
			IFNULL(Var_TelefonoDependenDOS, Cadena_Vacia) AS Var_TelefonoDependenDOS,

			IFNULL(Var_NombreDependenTRES, Cadena_Vacia) AS Var_NombreDependenTRES,
			IFNULL(Var_ParentescoDependenTRES, Cadena_Vacia) AS Var_ParentescoDependenTRES,
			IFNULL(Var_NacionDependenTRES, Cadena_Vacia) AS Var_NacionDependenTRES,
			IFNULL(Var_DomicilioDependenTRES, Cadena_Vacia) AS Var_DomicilioDependenTRES,
			IFNULL(Var_TelefonoDependenTRES, Cadena_Vacia) AS Var_TelefonoDependenTRES,

			IFNULL(Var_NombreDependenCUATRO, Cadena_Vacia) AS Var_NombreDependenCUATRO,
			IFNULL(Var_ParentescoDependenCUATRO, Cadena_Vacia) AS Var_ParentescoDependenCUATRO,
			IFNULL(Var_NacionDependenCUATRO, Cadena_Vacia) AS Var_NacionDependenCUATRO,
			IFNULL(Var_DomicilioDependenCUATRO, Cadena_Vacia) AS Var_DomicilioDependenCUATRO,
			IFNULL(Var_TelefonoDependenCUATRO, Cadena_Vacia) AS Var_TelefonoDependenCUATRO,

			IFNULL(Var_SucursalNombre, Cadena_Vacia) AS Var_SucursalNombre,
			CONCAT(Var_LugarSucursal, ' A ', UPPER(FNFECHACOMPLETA(Var_FechaSistema, 3))) AS Var_LugarYFecha;
		END IF;

		IF(Par_SeccionReporte = Vinculos_Sociedades) THEN
			SELECT
				CLI.NombreCompleto AS Var_NombreSocVinculo,
                CONCAT(FORMAT(DIR.PorcentajeAcciones,2), '%') AS Var_PorcentajeVinculo
			FROM DIRECTIVOS DIR
			INNER JOIN CLIENTES CLI ON DIR.ClienteID = CLI.ClienteID
			WHERE DIR.RelacionadoID = Par_ClienteID LIMIT 4;
		END IF;

END IF;
-- ****************************************** FIN SECCION PERSONA FISICA ******************************************




-- ***************************************** INICIO SECCION PERSONA MORAL *****************************************
IF(Par_TipoPersona = Persona_Moral) THEN
	-- DATOS DEL CLIENTE
	SELECT
		CLI.NombreCompleto, 		CLI.Nacion, 			CLI.Telefono, 			DIR.DireccionCompleta
	INTO
		Var_NombreCompleto,			Var_Nacion,				Var_Telefono, 			Var_DireccionCompleta
		FROM CLIENTES CLI
		LEFT JOIN DIRECCLIENTE DIR ON CLI.ClienteID = DIR.ClienteID
	    LEFT JOIN OCUPACIONES O ON O.OcupacionID = CLI.OcupacionID AND DIR.Oficial = Constante_SI
		WHERE CLI.ClienteID = Par_ClienteID LIMIT 1;


	SET Var_Nacion := CASE
		WHEN (Var_Nacion = 'N') THEN Nacionalidad_M
		WHEN (Var_Nacion = 'E') THEN Nacionalidad_E
	END;

	SELECT
		CON.Giro, 					SEC.Descripcion,
		CONCAT(
			IF(IFNULL(CON.PaisesExport, Cadena_Vacia) = Cadena_Vacia, '', CONCAT(CON.PaisesExport, ', ')),
			IF(IFNULL(CON.PaisesExport2, Cadena_Vacia) = Cadena_Vacia, '', CONCAT(CON.PaisesExport2, ', ')),
			IF(IFNULL(CON.PaisesExport3, Cadena_Vacia) = Cadena_Vacia, '', CONCAT(CON.PaisesExport3, ''))),
		CON.Estados_Presen, 		CON.IngAproxMes, 		CON.InstrumentosMonetarios, 	CON.TiposClientes,
		IF(CON.Exporta = Constante_SI OR CON.Importa = Constante_SI, Str_SI, Str_NO),
        CON.PFuenteIng,				CON.ImporteVta
	INTO
		Var_GiroMercantil,			Var_SectorEconomico,
		Var_PaisesOperacion,
		Var_EstadosCobertura,		Var_IngresosMensuales,	Var_InstrumentosMonetarios,		Var_TiposClientes,
		Var_ImportaExporta,
        Var_OrigenRecursos,			Var_MontosAproxClientes
		FROM CLIENTES CLI
		INNER JOIN CONOCIMIENTOCTE CON ON CLI.ClienteID = CON.ClienteID
		INNER JOIN SECTORESECONOM SEC ON SEC.SectorEcoID = CLI.SectorEconomico
		WHERE CLI.ClienteID = Par_ClienteID ;

	SET Var_TiposClientes := CASE
		WHEN (Var_TiposClientes = Persona_Fisica) THEN 'PERSONAS FISICAS'
		WHEN (Var_TiposClientes = Persona_Moral) THEN 'PERSONAS MORALES'
		ELSE Cadena_Vacia
	END;


	SET Var_InstrumentosMonetarios := CASE
		WHEN (Var_InstrumentosMonetarios = 'E') THEN 'EFECTIVO'
		WHEN (Var_InstrumentosMonetarios = 'C') THEN 'CHEQUE'
		WHEN (Var_InstrumentosMonetarios = 'T') THEN 'TRANSFERENCIA'
		ELSE Cadena_Vacia
	END;

	SET Var_IngresosMensuales := CASE
		WHEN (Var_IngresosMensuales = 'Ing1') THEN Constante_Ing1
		WHEN (Var_IngresosMensuales = 'Ing2') THEN Constante_Ing2
		WHEN (Var_IngresosMensuales = 'Ing3') THEN Constante_Ing3
		WHEN (Var_IngresosMensuales = 'Ing4') THEN Constante_Ing4
		ELSE Cadena_Vacia
	END;


	SET Var_RepresentanteLegal := (SELECT IFNULL(CLI.NombreCompleto, DIR.NombreCompleto)
									FROM DIRECTIVOS DIR
									LEFT JOIN CLIENTES CLI ON CLI.ClienteID = DIR.RelacionadoID
									WHERE DIR.ClienteID = Par_ClienteID AND DIR.CargoID = 3);



	IF(Par_SeccionReporte = Datos_Generales) THEN
		SELECT
			IFNULL(Var_NombreCompleto, Cadena_Vacia) AS Var_NombreCompleto,
			IFNULL(Var_Nacion, Cadena_Vacia) AS Var_Nacion,
			IFNULL(Var_Telefono, Cadena_Vacia) AS Var_Telefono,
			IFNULL(Var_TelTrabajo, Cadena_Vacia) AS Var_TelTrabajo,
			IFNULL(Var_DireccionCompleta, Cadena_Vacia) AS Var_DireccionCompleta,

			IFNULL(Var_GiroMercantil,Cadena_Vacia) AS Var_GiroMercantil,
			IFNULL(Var_OrigenOtrosIngresos,Cadena_Vacia) AS Var_OrigenOtrosIngresos,
			IFNULL(Var_DestinoOtrosIngresos,Cadena_Vacia) AS Var_DestinoOtrosIngresos,
			IFNULL(Var_SectorEconomico,Cadena_Vacia) AS Var_SectorEconomico,
			IFNULL(Var_PaisesOperacion,Cadena_Vacia) AS Var_PaisesOperacion,
			IFNULL(Var_EstadosCobertura,Cadena_Vacia) AS Var_EstadosCobertura,
			IFNULL(Var_TiposClientes,Cadena_Vacia) AS Var_TiposClientes,
			IFNULL(Var_IngresosMensuales, Cadena_Vacia) AS Var_IngresosMensuales,
			IFNULL(Var_InstrumentosMonetarios,Cadena_Vacia) AS Var_InstrumentosMonetarios,
			IFNULL(Var_MontosAproxClientes,Cadena_Vacia) AS Var_MontosAproxClientes,
			IFNULL(Var_ImportaExporta,Cadena_Vacia) AS Var_ImportaExporta,
			IFNULL(Var_RepresentanteLegal, Cadena_Vacia) AS Var_RepresentanteLegal,
            IFNULL(Var_OrigenRecursos, Cadena_Vacia) AS Var_OrigenRecursos,
            CONCAT('$',IFNULL(Var_MontosAproxClientes, Decimal_Cero)) AS Var_MontosAproxClientes,

			IFNULL(Var_SucursalNombre, Cadena_Vacia) AS Var_SucursalNombre,
			CONCAT(Var_LugarSucursal, ' A ', UPPER(FNFECHACOMPLETA(Var_FechaSistema, 3))) AS Var_LugarYFecha
			;
	END IF;

	IF(Par_SeccionReporte = Vinculos_Sociedades) THEN
		SELECT
			IFNULL(CLI.NombreCompleto, DIR.NombreCompleto) AS Var_NombreSocVinculo,
			CONCAT(FORMAT(IFNULL(DIR.PorcentajeAcciones, Decimal_Cero),2), '%') AS Var_PorcentajeSocVinculo,
		    CONCAT('$',FORMAT(IFNULL(DIR.ValorAcciones, Decimal_Cero),2)) AS Var_ValorAccionesSocVinculo,
		    IF(DIR.EsPropietarioReal = Constante_SI, Str_SI, Str_NO) AS Var_EsPropietarioReal,
		    IF(CON.PEPs = Constante_SI, Str_SI, Str_NO ) AS Var_PEPSocVinculo
		FROM DIRECTIVOS DIR
		LEFT JOIN CLIENTES CLI ON CLI.ClienteID = DIR.RelacionadoID
		LEFT JOIN CONOCIMIENTOCTE CON ON CLI.ClienteID = CON.ClienteID
		WHERE DIR.ClienteID = Par_ClienteID LIMIT 6;
		END IF;
END IF;
-- ******************************************* FIN SECCION PERSONA MORAL ******************************************
END TerminaStore$$