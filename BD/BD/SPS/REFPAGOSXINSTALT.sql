-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFPAGOSXINSTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REFPAGOSXINSTALT`;DELIMITER $$

CREATE PROCEDURE `REFPAGOSXINSTALT`(
/* REGISTRA LAS REFERENCIAS DE PAGO POR TIPO DE INSTRUMENTO */
	Par_TipoCanalID				INT(11), 		-- ID del tipo de canal sólo para ctas y creditos. Corresponde a TIPOCANAL
	Par_InstrumentoID			BIGINT(20), 	-- ID del instrumento (CuentaAhoID, CreditoID).
	Par_Origen					INT(11), 		-- Instituciones Bancarias 1.- Instituciones.
	Par_InstitucionID			INT(11), 		-- ID de INSTITUCIONES.
	Par_NombInstitucion			VARCHAR(100),	-- Nombre largo de la Institucion o del Tercero.

	Par_Referencia				VARCHAR(45),	-- Nombre de la Rerferencia (Alfanumérico).
    Par_TipoReferencia			CHAR(1),		-- Tipo de Referencias A = automatica, M = manual

	Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT(11),		-- Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Error
    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),

	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),

	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control     CHAR(15);
DECLARE	Var_RefPagoID	INT(11);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	SalidaSI        	CHAR(1);
DECLARE	SalidaNO        	CHAR(1);
DECLARE	EstatusActivo   	CHAR(1);
DECLARE	EstatusVigente		CHAR(1);
DECLARE	EstatusAutorizado	CHAR(1);
DECLARE	EstatusVencido   	CHAR(1);
DECLARE	EstatusCastigado	CHAR(1);
DECLARE	OrigenInstBanc  	INT(11);
DECLARE	TipoCanalCred   	INT(11);
DECLARE	TipoCanalCtas		INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia			:= '';				-- Cadena vacia
SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero				:= 0;				-- Entero Cero
SET	SalidaSI        		:= 'S';				-- Salida Si
SET	SalidaNO        		:= 'N'; 			-- Salida No
SET	EstatusActivo      		:= 'A'; 			-- Estatus Activo
SET	EstatusVigente     		:= 'V'; 			-- Estatus Vigente
SET	EstatusAutorizado  		:= 'A'; 			-- Estatus Autorizado
SET	EstatusVencido     		:= 'B'; 			-- Estatus Vencido
SET	EstatusCastigado   		:= 'K'; 			-- Estatus Castigado
SET	OrigenInstBanc      	:= 1; 				-- Tipo de Origen para Instituciones Bancarias
SET	TipoCanalCred       	:= 1; 				-- Tipo de Canal para Creditos
SET	TipoCanalCtas			:= 2;				-- Tipo de Canal para Cuentas
SET Aud_FechaActual 		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-REFPAGOSXINSTALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_TipoCanalID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Tipo de Canal esta Vacio.';
		SET Var_Control:= 'tipoCanalID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoCanalID, Entero_Cero)) NOT IN (TipoCanalCred,TipoCanalCtas)THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Tipo de Canal No es Valido.';
		SET Var_Control:= 'tipoCanalID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_InstrumentoID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'El Instrumento esta Vacio.';
		SET Var_Control:= 'instrumentoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoCanalID, Entero_Cero)) = TipoCanalCred THEN
		IF(NOT EXISTS(SELECT CreditoID FROM CREDITOS WHERE CreditoID=IFNULL(Par_InstrumentoID, Entero_Cero)
						AND Estatus IN(EstatusAutorizado,EstatusVigente,EstatusVencido,EstatusCastigado))) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El Credito No Existe o No es Valido.';
			SET Var_Control:= 'instrumentoID' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_TipoCanalID, Entero_Cero)) = TipoCanalCtas THEN
		IF(NOT EXISTS(SELECT CuentaAhoID FROM CUENTASAHO WHERE CuentaAhoID=IFNULL(Par_InstrumentoID, Entero_Cero)
						AND Estatus=EstatusActivo)) THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'La Cuenta de Ahorro No Existe o No es Valida.';
			SET Var_Control:= 'instrumentoID' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_Origen, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'El Origen esta Vacio.';
		SET Var_Control:= 'origenID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Origen, Entero_Cero)) != OrigenInstBanc THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'El Origen No es Valido.';
		SET Var_Control:= 'origenID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_InstitucionID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 8;
		SET Par_ErrMen := 'La Institucion Bancaria esta Vacia.';
		SET Var_Control:= 'institucionID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT InstitucionID FROM INSTITUCIONES WHERE InstitucionID=IFNULL(Par_InstitucionID, Entero_Cero))) THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen := 'La Institucion Bancaria No Existe o No es Valida.';
		SET Var_Control:= 'institucionID' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_NombInstitucion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NombInstitucion := (SELECT Nombre FROM INSTITUCIONES WHERE InstitucionID=IFNULL(Par_InstitucionID, Entero_Cero));
		SET Par_NombInstitucion := IFNULL(Par_NombInstitucion, Cadena_Vacia);
	END IF;

	IF(IFNULL(Par_Referencia, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 10;
		SET Par_ErrMen := 'La Referencia esta Vacia.';
		SET Var_Control:= 'referencia' ;
		LEAVE ManejoErrores;
	END IF;

	IF(EXISTS(SELECT RefPagoID FROM REFPAGOSXINST
					WHERE TipoCanalID = IFNULL(Par_TipoCanalID, Entero_Cero) AND Referencia = IFNULL(Par_Referencia, Cadena_Vacia)
						AND InstitucionID = IFNULL(Par_InstitucionID, Entero_Cero))) THEN
		SET Par_NumErr := 12;
		SET Par_ErrMen := CONCAT('La Referencia ya se Encuentra Registrada para el Tipo de Canal ',IF(Par_TipoCanalID=TipoCanalCred, 'Credito','Cuenta'),'.');
		SET Var_Control:= 'institucionID' ;
		LEAVE ManejoErrores;
    END IF;

    SET Var_RefPagoID := (SELECT IFNULL(MAX(RefPagoID),Entero_Cero) + 1 FROM REFPAGOSXINST);

	INSERT INTO REFPAGOSXINST(
		RefPagoID, 				TipoCanalID, 		InstrumentoID, 		Origen, 			InstitucionID,
		NombInstitucion, 		Referencia, 		TipoReferencia,
        EmpresaID, 				Usuario, 			FechaActual,		DireccionIP, 		ProgramaID,
        Sucursal, 				NumTransaccion)
	VALUES(
		Var_RefPagoID, 			Par_TipoCanalID, 	Par_InstrumentoID, 	Par_Origen, 		Par_InstitucionID,
		Par_NombInstitucion, 	Par_Referencia,		Par_TipoReferencia,
        Par_EmpresaID,			Aud_Usuario, 		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
        Aud_Sucursal,			Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Referencias Grabadas Exitosamente.';
	SET Var_Control:= 'instrumentoID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Var_RefPagoID AS Consecutivo;
END IF;

END TerminaStore$$