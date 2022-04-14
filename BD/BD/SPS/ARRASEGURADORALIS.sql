-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRASEGURADORALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRASEGURADORALIS`;DELIMITER $$

CREATE PROCEDURE `ARRASEGURADORALIS`(
# =====================================================================================
# -- STORED PROCEDURE PARA LISTAR LAS ASEGURADORAS
# =====================================================================================
	Par_Descripcion			VARCHAR(150), 			-- Descripcion de la marca
    Par_NumLis				TINYINT UNSIGNED,		-- Numero de lista

	Aud_EmpresaID			INT(11),				-- Id de la empresa
	Aud_Usuario         	INT(11),				-- Usuario
	Aud_FechaActual     	DATETIME,				-- Fecha actual
	Aud_DireccionIP     	VARCHAR(15),			-- Descripcion IP
	Aud_ProgramaID      	VARCHAR(50),			-- Id del programa
	Aud_Sucursal        	INT(11),				-- Numero de sucursal
	Aud_NumTransaccion  	BIGINT(20)				-- Numero de transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Lis_Aseguradoras	INT(11);		-- Lista para aseguradoras
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero
	DECLARE Var_SegMueble		INT(11);		-- Seguro mueble
	DECLARE Var_SegVida			INT(11);		-- Seguro de vida
	DECLARE Var_SegAmbos		INT(11);		-- Seguro mueble y de vida
	DECLARE Est_Activo			CHAR(1);		-- Estatus activo
	DECLARE Var_LisMueble		INT(11);		-- Lista de seguros mueble
	DECLARE Var_LisVida			INT(11);		-- Lista de seguros de vida

	-- Declaracion de Variables
    DECLARE Var_Descripcion 	VARCHAR(150);	-- Variable que almacena la descripcion de la marca

	-- Asignacion de Contantes
	SET Lis_Aseguradoras		:= 1;			-- Valor lista 1
	SET	Cadena_Vacia			:= '';			-- Valor de cadena vacia
	SET	Entero_Cero				:= 0;			-- Valor de entero cero.
	SET Var_SegMueble			:= 1;			-- Seguro mueble
	SET Var_SegVida				:= 2;			-- Seguro de vida
	SET Var_SegAmbos			:= 3;			-- Seguro mueble y de vida
	SET Est_Activo				:= 'A';			-- Estatus activo
	SET Var_LisMueble			:= 2;			-- Lista de seguros mueble
	SET Var_LisVida				:= 3;			-- Lista de seguros de vida

	 -- Valores por Default
	SET Par_Descripcion			:= IFNULL(Par_Descripcion,Cadena_Vacia);
	SET Par_NumLis				:= IFNULL(Par_NumLis,Entero_Cero);


	-- Consulta los datos de una marca --
	IF(Par_NumLis = Lis_Aseguradoras) THEN
		SET Var_Descripcion	:= CONCAT("%", Par_Descripcion, "%");

		SELECT	AseguradoraID,		Descripcion
			FROM	ARRASEGURADORA
			WHERE	Descripcion LIKE Var_Descripcion
			LIMIT 0, 15;
	END IF;

	-- Lista de aseguradoras mueble
	IF(Par_NumLis = Var_LisMueble) THEN
		SET Var_Descripcion	:= CONCAT("%", Par_Descripcion, "%");

		SELECT	AseguradoraID,		Descripcion
			FROM	ARRASEGURADORA
			WHERE	Descripcion LIKE Var_Descripcion
			  AND	TipoSeguro IN (Var_SegMueble, Var_SegAmbos)
			  AND	Estatus = Est_Activo
			LIMIT 0, 15;
	END IF;

	-- Lista de aseguradoras mueble
	IF(Par_NumLis = Var_LisVida) THEN
		SET Var_Descripcion	:= CONCAT("%", Par_Descripcion, "%");

		SELECT	AseguradoraID,		Descripcion
			FROM	ARRASEGURADORA
			WHERE	Descripcion LIKE Var_Descripcion
			  AND	TipoSeguro IN (Var_SegVida, Var_SegAmbos)
			  AND	Estatus = Est_Activo
			LIMIT 0, 15;
	END IF;

END TerminaStore$$