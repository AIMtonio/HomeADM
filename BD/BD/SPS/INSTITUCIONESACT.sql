-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUCIONESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITUCIONESACT`;
DELIMITER $$


CREATE PROCEDURE `INSTITUCIONESACT`(
# =====================================================================================
# ------- STORED PARA ACTUALIZAR LAS INSTITUCIONES ---------
# =====================================================================================
    Par_InstitucionID		INT(11),		-- ID  de la institucion
    Par_GeneraRefeDep		CHAR(1),		-- Genera referencia depositos S=si, N=no
    Par_AlgoritmoID			INT(11),		-- ID del algoritmo
    Par_NumConvenio			VARCHAR(45),	-- Indica el numero de convenio de la institucion bancaria con la financiera
    Par_ConvenioInter		VARCHAR(45),	-- Indicar el numero de convenio interbancaria del banco con la financiera
    Par_Domicilia			CHAR(1),		-- Indica si la Institucion Maneja Domiciliacion
    Par_NumContrato			CHAR(6),		-- Indica el numero de contrato
    Par_CveEmision			CHAR(6),		-- Indica la clave de emision
    Par_NumAct				TINYINT UNSIGNED,-- Numero de actualizacion

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
    	DECLARE Act_DepRef			INT(11);			-- Actualizacion 3 depositos referenciados
    	DECLARE Con_SI				CHAR(1);			-- Constante para SI
    	DECLARE Con_NO				CHAR(1);			-- Constante para NO

    -- ASIGNACIŃ DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Act_DepRef          	:= 3;
	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-INSTITUCIONESACT');
			SET Var_Control = 'SQLEXCEPTION';
		END;
        

        IF NOT EXISTS(SELECT InstitucionID FROM INSTITUCIONES WHERE InstitucionID = Par_InstitucionID)THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'La Institucion no Existe';
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Par_InstitucionID;
			LEAVE ManejoErrores;

        END IF;

		IF(IFNULL(Par_GeneraRefeDep, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El campo Genera Referencia Depositos esta Vacio';
			SET Var_Control		:= 'generaRefeDep';
			SET Var_Consecutivo	:= Par_GeneraRefeDep;
			LEAVE ManejoErrores;
		END IF;
        


		IF(Par_NumAct = Act_DepRef)THEN

			SET Aud_FechaActual := NOW();

            UPDATE INSTITUCIONES SET
				GeneraRefeDep  	= 	Par_GeneraRefeDep,
                AlgoritmoID		=	Par_AlgoritmoID,
                NumConvenio		=	Par_NumConvenio,
                ConvenioInter	=	Par_ConvenioInter,
                Domicilia 		=	Par_Domicilia,
                NumContrato		=	Par_NumContrato,
                CveEmision		=	Par_CveEmision,

				EmpresaID		=	Par_EmpresaID,
				Usuario			=	Aud_Usuario,
				FechaActual		=	Aud_FechaActual,
				DireccionIP		=	Aud_DireccionIP,
				ProgramaID		=	Aud_ProgramaID,
				Sucursal		=	Aud_Sucursal,
				NumTransaccion	=	Aud_NumTransaccion
			WHERE InstitucionID = Par_InstitucionID;

        END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Actualizacion Realizada Exitosamente: ',CAST(Par_InstitucionID AS CHAR) );
		SET Var_Control		:= 'institucionID';
		SET Var_Consecutivo	:= Par_InstitucionID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$
