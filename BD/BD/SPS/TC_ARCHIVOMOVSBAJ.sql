-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_ARCHIVOMOVSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_ARCHIVOMOVSBAJ`;
DELIMITER $$


CREATE PROCEDURE `TC_ARCHIVOMOVSBAJ`(
-- ---------------------------------------------------------------------------------
-- REGISTRA EL CONTENIDO DE LOS ARCHIVOS CARGADOS PARA ARCHIVOS EMI Y STATS
-- ---------------------------------------------------------------------------------
	Par_TipoArchivo			CHAR(1),			-- Parametro indica el tipo de archivo. (E = EMI, S = STATS)
	Par_FechaArchivo		DATE,				-- Parametro de fecha del archivo
	Par_NombreArchivo		VARCHAR(50),		-- Nombre del archivo
	Par_Registro			VARCHAR(520),		-- Contenido de la linea del archivo
    Par_NumTranCarga        BIGINT(20) ,      		-- Numero de transaccion

    Par_Salida              CHAR(1),       -- Salida
    INOUT Par_NumErr        INT(11),           -- Salida
    INOUT Par_ErrMen        VARCHAR(400),  -- Salida

    Aud_EmpresaID           INT(11) ,       -- Auditoria
    Aud_Usuario             INT(11),        -- Auditoria
    Aud_FechaActual         DATETIME ,      -- Auditoria
    Aud_DireccionIP         VARCHAR(15) ,   -- Auditoria
    Aud_ProgramaID          VARCHAR(50) ,   -- Auditoria
    Aud_Sucursal            INT(11) ,       -- Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Auditoria

)
TerminaStore:BEGIN
-- Declaracion de variables
DECLARE Var_NumRegistro			INT(11);	-- Numero de registros por transaccion
DECLARE Var_EstatusArch		 	CHAR(1);	-- Estatus inicial archivo R = Registrado
DECLARE Var_CantRegNoVal		INT(11);	-- Cantidad de registros no validos para eliminacion

-- Declaracion de constantes
DECLARE Cadena_Vacia   			VARCHAR(2);	-- Cadena vacia
DECLARE Entero_Cero				INT(1);		-- Entero cero
DECLARE Salida_SI       		CHAR(1);	-- Salida SI

-- Asignacion de constantes
SET Entero_Cero         		:= 0;			-- Entero cero
SET Salida_SI           		:= 'S';			-- Salida SI
SET Cadena_Vacia				:= '';			-- Cadena vacia

-- Asignacion de variables
SET Var_EstatusArch				:= 'R';			-- Estatus inicial R = Registrado
SET Var_NumRegistro				:= 0;			-- Numero registros por transaccion


ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_ARCHIVOMOVSBAJ');
			END;
			
    SELECT COUNT(FechaArchivo)
        INTO Var_CantRegNoVal
        FROM TC_ARCHIVOMOVS
        WHERE FechaArchivo = Par_FechaArchivo
        AND TipoArchivo = Par_TipoArchivo
        AND Estatus <> Var_EstatusArch;
        
	IF(Var_CantRegNoVal > Entero_Cero) THEN
		SET Par_NumErr:= 1;
		SET Par_ErrMen:= 'Existen registros que no se pueden eliminar por que se encuentran procesados.';
		LEAVE ManejoErrores;
	END IF;

    DELETE FROM TC_ARCHIVOMOVS
        WHERE FechaArchivo = Par_FechaArchivo
        AND TipoArchivo = Par_TipoArchivo;
        
	SET Par_NumErr:= 0;
    SET Par_ErrMen:= 'Eliminacion de archivos Exitoso';

END ManejoErrores;

   IF Par_Salida = Salida_SI THEN
        SELECT Par_NumErr AS NumErr,
               Par_ErrMen AS ErrMen;

    END IF;

END TerminaStore$$
