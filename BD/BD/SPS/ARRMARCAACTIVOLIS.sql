-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRMARCAACTIVOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRMARCAACTIVOLIS`;DELIMITER $$

CREATE PROCEDURE `ARRMARCAACTIVOLIS`(
# =====================================================================================
# -- STORED PROCEDURE PARA LISTAR LAS MARCAS REGISTRADAS
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
	DECLARE Lis_Marcas			INT(11);		-- Tipo de Lista
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero

	-- Declaracion de Variables
    DECLARE Var_Descripcion 	VARCHAR(150);	-- Variable que almacena la descripcion de la marca

	-- Asignacion de Contantes
	SET Lis_Marcas				:= 1;			-- Valor lista 1
	SET	Cadena_Vacia			:= '';			-- Valor de cadena vacia
	SET	Entero_Cero				:= 0;			-- Valor de entero cero.

	 -- Valores por Default
	SET Par_Descripcion			:= IFNULL(Par_Descripcion,Cadena_Vacia);
	SET Par_NumLis				:= IFNULL(Par_NumLis,Entero_Cero);


	-- Consulta los datos de una marca --
	IF(Par_NumLis = Lis_Marcas) THEN
		SET Var_Descripcion	:= CONCAT("%", Par_Descripcion, "%");

		SELECT	MarcaID,		Descripcion
			FROM	ARRMARCAACTIVO
			WHERE	Descripcion LIKE Var_Descripcion
			LIMIT 0, 15;
	END IF;

END TerminaStore$$