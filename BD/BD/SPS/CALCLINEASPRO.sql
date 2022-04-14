-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCLINEASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCLINEASPRO`;
DELIMITER $$

CREATE PROCEDURE `CALCLINEASPRO`(
-- ================================================================================================
-- ------ SP PARA CALCULAR NEGRITAS Y LONGITUD DE LINEA PARA PARRAFOS DINAMICOS DE LOS PRPTs ------
-- ================================================================================================
	Par_Parrafo             	VARCHAR(3000),  -- Parrafo completo a configurar
    Par_NumNegritas				INT(11),		-- Numero de caracteres en negrita que tendrá el parrafo
	Par_LongLinea     			INT(11),       	-- Numero de caracteres que tiene el renglon
    INOUT Par_NuevaLongLinea     INT(11),       -- Numero de caracteres que tendra el renglon
	INOUT Par_NuevoNumLineas     INT(11),   	-- Numero de renglones que tendra el parrafo

	Aud_EmpresaID           	INT(11),        -- Parametro Auditoria
	Aud_Usuario             	INT(11),        -- Parametro Auditoria
	Aud_FechaActual         	DATETIME,       -- Parametro Auditoria
	Aud_DireccionIP         	VARCHAR(15),    -- Parametro Auditoria
	Aud_ProgramaID          	VARCHAR(50),    -- Parametro Auditoria
	Aud_Sucursal            	INT(11),        -- Parametro Auditoria
	Aud_NumTransaccion      	BIGINT(20)      -- Parametro Auditoria
)
TerminaStore: BEGIN
	
    DECLARE Var_LongLinea 	INT(11);		-- Numero de caracteres por renglon
    DECLARE Var_NumLineas 	INT(11);		-- Numero de renglones del parrafo
    DECLARE Var_Cadena 		VARCHAR(3000);	-- Cadena original
    DECLARE Var_LongCadena	INT(11);		-- Longitud de cadena original
    DECLARE Var_CantNegri	DOUBLE(12,2);	-- Cantidad de negritas
    DECLARE Var_LongCadNue	INT(11);		-- Longitud de la nueva cadena
    DECLARE Var_Control		VARCHAR(50);	-- Variable de control
    
	ManejoErrores:BEGIN
	
		SET Var_LongLinea := Par_LongLinea;
		SET Var_NumLineas := 0;

        -- Limpiar carcteres de formato RTF
        SET Par_Parrafo := REPLACE(Par_Parrafo, '{\\rtf1 ', '');
		SET Par_Parrafo := REPLACE(Par_Parrafo, '{\\b ', '');
		SET Par_Parrafo := REPLACE(Par_Parrafo, '}', '');
        -- Si el parrafo tiene mas caracteres especiales del formato,
        -- agregar los replace correspondientes y verificar que no afecte
        -- al parrafo, ya que este SP es utilizado en varios parrafos.

		SET Var_Cadena := Par_Parrafo;

		SET Var_LongCadena := LENGTH(Var_Cadena);

		-- Nuevos numeros de linea por parrafo
		SET Var_NumLineas := CEIL(Var_LongCadena/Var_LongLinea); 
		SET Var_CantNegri := CEIL(Par_NumNegritas*0.5);

		SET Var_LongCadNue := Var_LongCadena-Var_CantNegri;


		SET Var_NumLineas := CEIL(Var_LongCadNue/Var_LongLinea);
		SET Var_LongLinea := CEIL(Var_LongCadNue/Var_NumLineas); 

        SET Par_NuevaLongLinea := Var_LongLinea;
        SET Par_NuevoNumLineas := Var_NumLineas;
        
	END ManejoErrores;
		
END TerminaStore$$
