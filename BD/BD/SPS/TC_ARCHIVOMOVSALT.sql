-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_ARCHIVOMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_ARCHIVOMOVSALT`;
DELIMITER $$


CREATE PROCEDURE `TC_ARCHIVOMOVSALT`(
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
DECLARE Var_NumRegistro		INT(11);	-- Numero de registros por transaccion
DECLARE Var_EstatusArch		 CHAR(1);	-- Estatus inicial archivo R = Registrado

-- Declaracion de constantes
DECLARE Cadena_Vacia   		VARCHAR(2);	-- Cadena vacia
DECLARE Entero_Cero			INT(1);		-- Entero cero
DECLARE Salida_SI       	CHAR(1);	-- Salida SI

-- Asignacion de constantes
SET Entero_Cero         := 0;			-- Entero cero
SET Salida_SI           := 'S';			-- Salida SI
SET Cadena_Vacia		:= '';			-- Cadena vacia

-- Asignacion de variables
SET Var_EstatusArch		:= 'R';			-- Estatus inicial R = Registrado
SET Var_NumRegistro		:= 0;			-- Numero registros por transaccion


ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_ARCHIVOMOVS');
			END;

    SELECT  MAX(NumLinea)
    INTO Var_NumRegistro
    FROM TC_ARCHIVOMOVS
    WHERE NumTranCarga = Par_NumTranCarga;

    SET Var_NumRegistro := IFNULL(Var_NumRegistro,Entero_Cero)+1;

    INSERT INTO TC_ARCHIVOMOVS( TipoArchivo,		FechaArchivo,		NombreArchivo,		Registro,		NumTranCarga,
								Estatus,			NumLinea,			MotivoCancel,	EmpresaID,			Usuario,			
								FechaActual,		DireccionIP,		ProgramaID,		Sucursal,			NumTransaccion)
								
	VALUES( Par_TipoArchivo,		Par_FechaArchivo,		Par_NombreArchivo,		Par_Registro,		Par_NumTranCarga,
			Var_EstatusArch,		Var_NumRegistro,		Cadena_Vacia,		Aud_EmpresaID,			Aud_Usuario, 			
			Aud_FechaActual,    	Aud_DireccionIP,    	Aud_ProgramaID, 	Aud_Sucursal,			Aud_NumTransaccion);

    SET Par_NumErr:= 0;
    SET Par_ErrMen:= 'Registro Contenido Exitoso';

END ManejoErrores;

   IF Par_Salida = Salida_SI THEN
        SELECT Par_NumErr AS NumErr,
               Par_ErrMen AS ErrMen;

    END IF;

END TerminaStore$$
