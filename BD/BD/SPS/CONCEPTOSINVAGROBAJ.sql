-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSINVAGROBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSINVAGROBAJ`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSINVAGROBAJ`(
# =====================================================================================
# ------- STORE PARA  DAR DE BAJA CONCEPTOS  DE INVERSION---------
# =====================================================================================
	Par_SolicitudID		BIGINT(20),				-- Solicitud de credito
    Par_ClienteID		INT(11),				-- ID dcel cliente
	Par_TipoRecurso		CHAR(2),				-- Tipo de recurso.

    Par_Salida          CHAR(1),            	-- indca una salida
    INOUT Par_NumErr    INT(11),				-- numero de error
    INOUT Par_ErrMen    VARCHAR(400),			-- mensaje de error

    Par_EmpresaID       INT(11),    			-- parametros de auditoria
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

    -- Declacion de Variables
    DECLARE Var_Control         VARCHAR(100); 			-- Variable de control
    DECLARE Var_Consecutivo     BIGINT(20);     		-- consecutivo
	DECLARE Var_ClienteID       INT(11);				-- clienteID
	DECLARE Var_SaldoTotal 		DECIMAL(14,2);			-- Saldo Disponible del credito
	DECLARE Var_ConcepFiraID    INT(11);				-- ID concepto Fira
	DECLARE Var_SolicitudCre	BIGINT(20);
    -- Declaracion de constantes
    DECLARE Entero_Cero         INT(11);				-- entero cero
    DECLARE Entero_Uno			INT(11);				-- entero uno
    DECLARE Cadena_Vacia        CHAR(1);				-- cadena vacia
    DECLARE Salida_SI           CHAR(1);    			-- salida si
    DECLARE Salida_NO           CHAR(1);    			-- salida no
    DECLARE Decimal_Cero        DECIMAL(14,2);			-- DECIMAL cero
	DECLARE Fecha_Vacia  		DATE;					-- fecha vacia
    DECLARE DescripcionMov		VARCHAR(100);			-- descripcion del novimiento en caso de que venga vacio
	DECLARE Es_Agropecuario		CHAR(1);				-- INDICA QUE SI ES AGRO
    -- Asignacion de constantes
    SET Entero_Cero         := 0;               -- Entero Cero
    SET Entero_Uno			:= 1;				-- Entero Uno
    SET Cadena_Vacia        := '';              -- Cadena Vacia
    SET Salida_SI           := 'S';             -- Salida en Pantalla SI
    SET Salida_NO           := 'N';             -- Salida en Pantalla NO
    SET Decimal_Cero        := 0.00;            -- DECIMAL Cero
    SET Es_Agropecuario		:= 'S';
	SET Fecha_Vacia     	:= '1900-01-01';

    ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CONCEPTOSINVAGROBAJ');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		-- Asignamos valor por defaul a varibles
		SET Aud_FechaActual  	:=  NOW();

		 IF(IFNULL(Par_SolicitudID, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'El Numero de Solicitud Esta Vacio.';
            SET Var_Control:= 'solicitudCreditoID' ;
            LEAVE ManejoErrores;
         END IF;

         SELECT  SolicitudCreditoID     INTO    Var_SolicitudCre
            FROM SOLICITUDCREDITO
            WHERE  SolicitudCreditoID  = Par_SolicitudID
				AND ClienteID =Par_ClienteID
                AND EsAgropecuario = Es_Agropecuario;

		IF(IFNULL(Var_SolicitudCre, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Numero de Solicitud No Existe.';
			SET Var_Control:= 'solicitudCreditoID' ;
			LEAVE ManejoErrores;
		 END IF;

        IF(IFNULL(Par_ClienteID, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr := 3;
            SET Par_ErrMen := 'El Numero de Cliente esta Vacio.';
            SET Var_Control:= 'clienteID' ;
            LEAVE ManejoErrores;
        END IF;


        IF(IFNULL(Par_TipoRecurso, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := 5;
            SET Par_ErrMen := 'El Tipo de Recurso esta Vacio.';
            SET Var_Control:= 'tipoRecurso' ;
            LEAVE ManejoErrores;
        END IF;


       DELETE FROM CONCEPTOINVERAGRO WHERE SolicitudCreditoID= Par_SolicitudID
			AND ClienteID =Par_ClienteID
			AND TipoRecurso = Par_TipoRecurso;


		SET     Par_NumErr 		:= 0;
		SET     Par_ErrMen 		:= CONCAT('Conceptos de Inversion Eliminados Exitosamente: ', CONVERT(Par_SolicitudID, CHAR));
		SET     Var_Control 	:= 'solicitudCreditoID';
        SET     Var_Consecutivo := Par_SolicitudID;

    END ManejoErrores;

       IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr 		AS NumErr,
					Par_ErrMen 		AS ErrMen,
					Var_Control 	AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$