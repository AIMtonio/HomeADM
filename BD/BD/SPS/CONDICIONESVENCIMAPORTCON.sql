-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONDICIONESVENCIMAPORTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONDICIONESVENCIMAPORTCON`;
DELIMITER $$

CREATE PROCEDURE `CONDICIONESVENCIMAPORTCON`(
# ====================================================================================
# ------ SP PARA CONSULTAR LAS CONDICIONES DE VENCIMIENTO DE UNA APORTACION-----------
# ====================================================================================
	Par_AportacionID		INT(11),			-- ID de la aportacion, hace referencia a la tabla (APORTACIONES)
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de Consulta
	Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria

	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Existe			CHAR(1);		-- Si / No existe el registro de las condiciones de vencimiento
	DECLARE Var_ReinversionAutom  CHAR(1);		-- Si / No Reinvierte automaticamente las condiciones
	DECLARE Var_TasaSugerida	DECIMAL(12,4);	-- Tasa sugerida por el sistema de acuerdo al monto global.
	DECLARE Var_ClienteID		INT(11);		-- Número de Cliente.
	DECLARE Var_TipoAportID		INT(11);		-- Tipo de aportación.
	DECLARE Var_SucursalID		INT(11);		-- Número de la Sucursal.
	DECLARE Var_Calificacion	CHAR(1);		-- Calificación del cliente.

  -- DECLARACION DE CONSTANTES
  DECLARE Cadena_Vacia      CHAR(1);      -- Constante Cadena Vacia ('')
  DECLARE Entero_Cero       TINYINT;      -- Constante Entero Cero (0)
  DECLARE Constante_NO      CHAR(1);      -- Constante NO (N)
  DECLARE Constante_SI      CHAR(1);      -- Constante SI (S)
  DECLARE Decimal_Cero      DECIMAL(12,2);    -- Constante Decimal Cero (00.00)
  DECLARE Fecha_Vacia       DATE;       -- Fecha Vacia
  DECLARE Con_Principal     TINYINT UNSIGNED; -- Consulta Principal
  DECLARE Con_Existe        TINYINT UNSIGNED; -- Consulta si existen las condiciones de vencimiento
  DECLARE Con_Estatus       TINYINT UNSIGNED; -- Consulta el estatus de las condiciones de vencimiento



  -- ASIGNACION DE CONSTANTES
  SET Cadena_Vacia      := '';
  SET Entero_Cero       := 0;
  SET Constante_NO      := 'N';
  SET Constante_SI      := 'S';
  SET Decimal_Cero      := 00.00;
  SET Fecha_Vacia       := '1900-01-01';
  SET Con_Principal       := 1;
  SET Con_Existe        := 2;
  SET Con_Estatus       := 3;


	-- 1) Consulta Principal
	IF(Par_NumCon = Con_Principal) THEN
		SET Var_TipoAportID		:= (SELECT TipoAportacionID FROM APORTACIONES WHERE AportacionID = Par_AportacionID);
		SET Var_ClienteID		:= (SELECT ClienteID FROM APORTACIONES WHERE AportacionID = Par_AportacionID);
		SET Var_SucursalID		:= Aud_Sucursal;
		SET Var_Calificacion	:= (SELECT CalificaCredito FROM CLIENTES WHERE ClienteID = Var_ClienteID);

		SELECT
			AportacionID,	ReinversionAutomatica,	TipoReinversion,	OpcionAportID,		Cantidad,
			Monto,			MontoRenovacion,		MontoGlobal,		TipoPago,			DiaPago,
			Plazo,			PlazoOriginal,			FechaInicio,		FechaVencimiento,	TasaBruta,
			TasaISR,		TasaNeta,				CapitalizaInteres,	GatNominal,			InteresGenerado,
			ISRRetener,		InteresRecibir,			TotalRecibir,		Notas,				IFNULL(Especificaciones, Cadena_Vacia) AS Especificaciones,
			Estatus,		Reinversion,			GatReal,			ConsolidarSaldos,	Condiciones,
			Var_TipoAportID AS TipoAportID,			ROUND(FUNCIONTASAAPORTACION(Var_TipoAportID, Plazo, MontoGlobal, Var_Calificacion, Var_SucursalID),2) AS TasaSAFI
		FROM CONDICIONESVENCIMAPORT WHERE AportacionID = Par_AportacionID;
	END IF;


	-- 2) Consulta si existe el registro en la tabla CONDICIONESVENCIMAPORT
	IF(Par_NumCon = Con_Existe) THEN
		SET Var_ReinversionAutom := Constante_NO;
		SET Var_Existe = (SELECT IF(NOT EXISTS(SELECT AportacionID
							FROM CONDICIONESVENCIMAPORT
							WHERE AportacionID = Par_AportacionID), Constante_NO, Constante_SI));

		IF(Var_Existe = Constante_SI) THEN
			SET Var_ReinversionAutom := (SELECT ReinversionAutomatica
											FROM CONDICIONESVENCIMAPORT
											WHERE AportacionID = Par_AportacionID LIMIT 1);
		END IF;

		SELECT IFNULL(Var_ReinversionAutom, Constante_NO) AS Existe;
	END IF;


	-- 3) Consulta el estatus de las aportaciones
	IF(Par_NumCon = Con_Estatus) THEN
		SELECT Estatus
			FROM CONDICIONESVENCIMAPORT  WHERE AportacionID = Par_AportacionID;
	END IF;

END TerminaStore$$