-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPARCRESPUESTASANBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPARCRESPUESTASANBAJ`;
DELIMITER $$

CREATE PROCEDURE `DISPARCRESPUESTASANBAJ`(
-- SP PARA DAR DE BAJA LOS ARCHIVOS DE RESPUESTA DE SANTANDER
    Par_NombreArchivo	VARCHAR(100),		-- NOMBRE DEL ARCHIVO
    Par_TipoBaj			TINYINT UNSIGNED, 	-- TIPO DE BAJA
    Par_Salida          CHAR(1),			-- SALIDA
    INOUT Par_NumErr    INT(11),			-- NUMEOR DE ERROR
    INOUT Par_ErrMen    VARCHAR(400),		-- MENSAJE DE ERRO
    
    Aud_EmpresaID       INT(11),    		-- AUDITORIA
    Aud_Usuario         INT(11),			-- AUDITORIA
    Aud_FechaActual     DATETIME,			-- AUDITORIA
    Aud_DireccionIP     VARCHAR(15),		-- AUDITORIA
    Aud_ProgramaID      VARCHAR(50),		-- AUDITORIA
    Aud_Sucursal        INT(11),			-- AUDITORIA
    Aud_NumTransaccion  BIGINT(20)			-- AUDITORIA
        )
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Control				VARCHAR(25);	-- CONTROL
    DECLARE	Var_Consecutivo			BIGINT(12);		-- CONSECUTIVO
    
	-- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia		CHAR(1);		-- CADENA VACIA
    DECLARE Entero_Cero			INT(11);		-- ENTERO CERO
	DECLARE SalidaNO    		CHAR(1);	-- SALIDA NO
	DECLARE SalidaSI    		CHAR(1); 	-- SALIDA SI
	DECLARE BajaCtasActivas		INT(11);	-- BAJA DE CUENTAS ACTIVAS
	DECLARE BajaCtaspendientes	INT(11);	-- BAJA DE CUENTAS PENDIENTES
	DECLARE BajaDisTransfer		INT(11);	-- BAJA DE INF. DE TRANSFERENCIAS
	DECLARE BajaOrdenPag		INT(11);	-- BAJA DE ORDENES DE PAGO
	DECLARE BajaDatBasuraOrdPag	INT(11);	-- BAJA DE REGISTROS BASURA DE ORDENES DE PAGO
    
	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia       		:= '';
	SET Entero_Cero        		:= 0;
	SET SalidaNO        		:= 'N';
	SET SalidaSI        		:= 'S'; 
	SET BajaCtasActivas			:= 1;
	SET BajaCtaspendientes		:= 2;
	SET BajaDisTransfer			:= 3;
	SET BajaOrdenPag			:= 4;
	SET BajaDatBasuraOrdPag		:= 5;
    
    ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-DISPARCRESPUESTASANBAJ');
		END;
        
        SET Par_NombreArchivo:=IFNULL(Par_NombreArchivo,Cadena_Vacia);
        SET Aud_NumTransaccion:=IFNULL(Aud_NumTransaccion,Entero_Cero);
        SET Par_TipoBaj:=IFNULL(Par_TipoBaj,Entero_Cero);
        
        
        IF(Par_NombreArchivo=Cadena_Vacia)THEN
			SET Par_NumErr		:= 1;
			SET Par_ErrMen 		:= 'El Archivo Esta Vacio.';
			SET Var_Control		:= 'rutaArchivo';
            LEAVE ManejoErrores;
        END IF;
        
         IF(Aud_NumTransaccion=Entero_Cero)THEN
			SET Par_NumErr		:= 2;
			SET Par_ErrMen 		:= 'El Folio Esta Vacio.';
			SET Var_Control		:= 'rutaArchivo';
            LEAVE ManejoErrores;
        END IF;
        
        IF(Par_TipoBaj NOT IN(BajaCtasActivas,BajaCtaspendientes, BajaDisTransfer, BajaOrdenPag, BajaDatBasuraOrdPag))THEN
			SET Par_NumErr		:= 3;
			SET Par_ErrMen 		:= 'El Tipo de Baja No Existe.';
			SET Var_Control		:= 'rutaArchivo';
            LEAVE ManejoErrores;
        END IF;
        
		-- BAJA DE CUENTAS ACTIVAS
		IF(Par_TipoBaj=BajaCtasActivas)THEN
			DELETE FROM DISPCTAACTIVAS
				WHERE NombreArchivo=Par_NombreArchivo
				AND NumTransaccion=Aud_NumTransaccion;
		END IF;
		
		-- BAJA DE CUENTAS PENDIENTES
		IF(Par_TipoBaj=BajaCtaspendientes)THEN
			DELETE FROM DISPCTAPENDIENTES
				WHERE NombreArchivo=Par_NombreArchivo
				AND NumTransaccion=Aud_NumTransaccion;
		END IF;
		
		-- BAJA DE INF. DE TRANSFERENCIAS
		IF(Par_TipoBaj=BajaDisTransfer)THEN
			DELETE FROM DISPTRANSFERENCIASAN
				WHERE NombreArchivo=Par_NombreArchivo
				AND NumTransaccion=Aud_NumTransaccion;
                
			-- ELIMINAMOS LOS DATOS DE LA TEMPORAL
			DELETE FROM TMPDISPERSIONESSANTANDER 
				WHERE NombreArchivo=Par_NombreArchivo 
				AND NumTransaccion=Aud_NumTransaccion;
		END IF;
        
        -- BAJA DE INF. DE ORDENES DE PAGOS
		IF(Par_TipoBaj=BajaOrdenPag)THEN
			DELETE FROM DISPORDENPAGOSAN
				WHERE NombreArchivo=Par_NombreArchivo
				AND NumTransaccion=Aud_NumTransaccion;
		END IF;
        
         -- BAJA DE INF. BASURA DE ORDENES DE PAGO
		IF(Par_TipoBaj=BajaDatBasuraOrdPag)THEN
			DELETE FROM DISPORDENPAGOSAN
				WHERE NombreArchivo=Par_NombreArchivo
				AND NumTransaccion=Aud_NumTransaccion
                AND IFNULL(Estatus,'')=''
                AND IFNULL(Importe,'')=''
                AND IFNULL(Concepto,'')='';
		END IF;
        
        SET Par_NumErr		:= 0;
		SET Par_ErrMen 		:= 'Datos Eliminados Correctamente.';
		SET Var_Control		:= 'rutaArchivo';
        
        
    END ManejoErrores;
        
    IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
		 LEAVE TerminaStore;
	end if;

END TerminaStore$$