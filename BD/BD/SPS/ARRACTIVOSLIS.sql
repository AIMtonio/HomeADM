-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRACTIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRACTIVOSLIS`;DELIMITER $$

CREATE PROCEDURE `ARRACTIVOSLIS`(
# =====================================================================================
# -- STORED PROCEDURE PARA LISTAR LOS ACTIVOS REGISTRADOS EN EL SISTEMA
# =====================================================================================
	Par_Descripcion			VARCHAR(150),		-- Descripcion del Activo
	Par_TipoActivo          INT(11),            -- Tipo de Activo: 1 = autos, 2= muebles
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de la lista

	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
	)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Descripcion		VARCHAR(150);	-- Variable que almacena la descripcion pasada como parametro.

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero
	DECLARE	Decimal_Cero		DECIMAL(14,2);	-- Decimal cero

	DECLARE Lis_ActivoInactivo 	INT(11);		-- Lista de Activos e Inactivos
	DECLARE Lis_Activos 	    INT(11);		-- Lista de Activos
	DECLARE Est_Activo			CHAR(1);		-- Indica el estatus activo A=activo
    DECLARE Est_Inactivo		CHAR(1);		-- Indica el estatus inactivo I=inactivo
    DECLARE Est_Ligado		    CHAR(1);		-- Indica el estatus ligado o asociado = L


	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Valor de cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Valor de fecha vacia.
	SET	Entero_Cero				:= 0;				-- Valor de entero cero.
	SET	Decimal_Cero			:= 0.0;				-- Valor de decimal cero.

	SET Lis_ActivoInactivo		:= 1;				-- Valor lista 1
	SET Lis_Activos		        := 2;				-- Valor lista 2
	SET Est_Activo			    := 'A';      		-- Estatus Activo=A
	SET Est_Inactivo			:= 'I';      		-- Estatus Inactivo=I
	SET Est_Ligado			    := 'L';      		-- Estatus Ligado/Asociado=L

	-- Valores por Default
	SET Par_Descripcion			:= IFNULL(Par_Descripcion,Cadena_Vacia);
	SET Par_TipoActivo			:= IFNULL(Par_TipoActivo,Entero_Cero);
	SET Par_NumLis				:= IFNULL(Par_NumLis,Entero_Cero);

	-- Lista: 1
	IF (Par_NumLis = Lis_ActivoInactivo) THEN
		SET Var_Descripcion	:= CONCAT("%", Par_Descripcion, "%");
		SELECT  ActivoID,    Descripcion
			FROM ARRACTIVOS
			WHERE	Descripcion  LIKE Var_Descripcion
			  AND	TipoActivo = Par_TipoActivo
			  AND	Estatus IN (Est_Activo,Est_Inactivo, Est_Ligado)
			ORDER BY ActivoID
			LIMIT 0, 15;
	END IF;

	-- Lista:2
	IF (Par_NumLis = Lis_Activos) THEN
		SET Var_Descripcion	:= CONCAT("%", Par_Descripcion, "%");
		SELECT  ActivoID,    Descripcion
			FROM ARRACTIVOS
			WHERE	Descripcion  LIKE Var_Descripcion
			  AND	TipoActivo = Par_TipoActivo
			  AND	Estatus = Est_Activo
			ORDER BY ActivoID
			LIMIT 0, 15;
	END IF;

	-- fin del sp
END TerminaStore$$