DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASSANTANDERALT`;

DELIMITER $$
CREATE PROCEDURE `CUENTASSANTANDERALT`(
	Par_SolicitudCreditoID 	BIGINT(20),
	Par_ClienteID 			INT(11),
	Par_TipoCtaSAFIID 		CHAR(1),
	Par_TipoCuenta 			VARCHAR(6),
	Par_NumeroCta          	VARCHAR(20),
	Par_Titular             VARCHAR(200),
	Par_ClaveBanco			VARCHAR(5),
	Par_PazaBanxico			INT(11),
	Par_SucursalID			INT(11),
	Par_TipoCta 			CHAR(4),
	Par_BenefAppPaterno 	VARCHAR(50),
	Par_BenefAppMaterno 	VARCHAR(50),
	Par_BenefNombre         VARCHAR(200),
	Par_BenefDireccion		VARCHAR(500),
	Par_BenefCiudad         VARCHAR(100),
	Par_Estatus 			CHAR(3),
	Par_DesEstatus 			VARCHAR(100),
	Par_FechaRegistro 		DATE,
	Par_Salida				CHAR(1), 			-- SALIDA
	INOUT Par_NumErr		INT(11),			-- NUM ERROR
	INOUT Par_ErrMen		VARCHAR(400),		-- MENSAJE DE ERROR
	Aud_EmpresaID			INT(11),			-- AUDITORIA    
	Aud_Usuario				INT(11),			-- AUDITORIA
    
	Aud_FechaActual			DATETIME,			-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),		-- AUDITORIA
	Aud_Sucursal			INT(11),			-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)			-- AUDITORIA
)
TerminaStore:BEGIN

	-- DECLARACIO DE VARIABLES
    DECLARE Var_Control			VARCHAR(25);
    DECLARE Var_NumeroCta       VARCHAR(20);

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);		-- CADENA VACIA
	DECLARE Fecha_Vacia			DATE;			-- FECHA VACIA
	DECLARE Entero_Cero			INT;			-- ENTERO CERO
	DECLARE SiOficial			CHAR(1);		-- SI OFICIAL
	DECLARE Salida_SI			CHAR(1);		-- SALIDA SI
	DECLARE Salida_No			CHAR(1);		-- SALIDA NO
	DECLARE EstatusReg			CHAR(1);		-- ESTATUS REGISTRADO
	DECLARE EstatusEnv			CHAR(1);		-- ESTATUS ENVIADA
	DECLARE NumPazaBanxico		INT(11);		-- NUMERO DE PLAZA ANTE BANXICO
	DECLARE Sucursal			INT(11);		-- NUMERO DE SUCURSAL
	DECLARE TipoCtaSantander	CHAR(1);		-- TIPO DE CUENTA SANTANDER 
	DECLARE TipoCtaOtros		CHAR(1);		-- TIPO DE CUENTA OTROS
	DECLARE DesTipoCtaSantan	VARCHAR(6);		-- DESCRIPCION TIPO DE CUENTA SANTANDER
	DECLARE DesTipoCtaOtros		VARCHAR(6);		-- DESCRIPCION TIPO DE CUENTA OTROS
	DECLARE TipoTranAlta		INT(11);		-- TIPO DE TRANSACCION DE ALTA

	

	-- ASIGNACION DE CONSTANTES
    SET TipoTranAlta		:= 1;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET SiOficial			:= 'S';
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET EstatusReg			:= 'R';
	SET EstatusEnv			:= 'E';
	SET NumPazaBanxico		:= 3954;
	SET Sucursal			:= '00001';
	SET TipoCtaSantander	:= 'A';
	SET TipoCtaOtros		:= 'O';
	SET DesTipoCtaSantan	:= 'SANTAN';
	SET DesTipoCtaOtros		:= 'EXTRNA';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASSANTANDERALT');
		END;


		SET Par_SolicitudCreditoID := IFNULL(Par_SolicitudCreditoID,Entero_Cero);
		SET Par_ClienteID := IFNULL(Par_ClienteID,Entero_Cero);
		SET Par_TipoCtaSAFIID := IFNULL(Par_TipoCtaSAFIID,Cadena_Vacia);
		SET Par_TipoCuenta := IFNULL(Par_TipoCuenta,Cadena_Vacia);
		SET Par_NumeroCta := IFNULL(TRIM(Par_NumeroCta),Cadena_Vacia);
		SET Par_Titular :=IFNULL(Par_Titular,Cadena_Vacia);
		SET Par_ClaveBanco := IFNULL(Par_ClaveBanco,Cadena_Vacia);
		SET Par_PazaBanxico := IFNULL(Par_PazaBanxico,Entero_Cero);
		SET Par_SucursalID := IFNULL(Par_SucursalID,Entero_Cero);
		SET Par_TipoCta := IFNULL(Par_TipoCta,Cadena_Vacia);
		SET Par_BenefAppPaterno := IFNULL(Par_BenefAppPaterno,Cadena_Vacia);
		SET Par_BenefAppMaterno := IFNULL(Par_BenefAppMaterno,Cadena_Vacia);
		SET Par_BenefNombre := IFNULL(Par_BenefNombre,Cadena_Vacia);
		SET Par_BenefDireccion := IFNULL(Par_BenefDireccion,Cadena_Vacia);
		SET Par_BenefCiudad := IFNULL(Par_BenefCiudad,Cadena_Vacia);
		SET Par_Estatus := IFNULL(Par_Estatus,Cadena_Vacia);
		SET Par_DesEstatus := IFNULL(Par_DesEstatus,Cadena_Vacia);
		SET Par_FechaRegistro := IFNULL(Par_FechaRegistro,Fecha_Vacia);


		SET Par_TipoCtaSAFIID := (SELECT IF(LENGTH(Par_NumeroCta)= 18,TipoCtaOtros,TipoCtaSantander));

		SET Par_TipoCuenta := (SELECT IF(LENGTH(Par_NumeroCta)= 18,DesTipoCtaOtros,DesTipoCtaSantan));

		SET Par_ClaveBanco := (SELECT IFNULL(CAT.ClaveTransfer,Cadena_Vacia) FROM INSTITUCIONES INS 
			INNER JOIN CATBANCOSTRANFER CAT ON INS.ClaveParticipaSpei=CAT.BancoID
			WHERE IFNULL(INS.Folio,0) IN(SUBSTRING(Par_NumeroCta, 1,3)));

		SET Par_PazaBanxico := NumPazaBanxico;

		SET Par_SucursalID	:= Sucursal;

		SET Par_TipoCta := (SELECT IF(LENGTH(Par_NumeroCta)= 18,'40','02'));

		SET Par_Estatus := EstatusEnv;


		SELECT NumeroCta INTO Var_NumeroCta FROM CUENTASSANTANDER WHERE NumeroCta = Par_NumeroCta LIMIT 1;


			SET Par_BenefNombre := Par_Titular;

		IF IFNULL(Var_NumeroCta,Entero_Cero) = Entero_Cero THEN
			INSERT INTO CUENTASSANTANDER
						(SolicitudCreditoID,	ClienteID,			TipoCtaSAFIID,	TipoCuenta,		NumeroCta,
						Titular, 				ClaveBanco,			PazaBanxico,	SucursalID, 	TipoCta,
						BenefAppPaterno, 		BenefAppMaterno,	BenefNombre, 	BenefDireccion, BenefCiudad,
						Estatus, 				DesEstatus, 		FechaRegistro, 	EmpresaID, 		Usuario,
						FechaActual, 			DireccionIP, 		ProgramaID, 	Sucursal, 		NumTransaccion)     
			VALUES		(Par_SolicitudCreditoID,	Par_ClienteID,			Par_TipoCtaSAFIID,		Par_TipoCuenta,		Par_NumeroCta,
						Par_Titular,				Par_ClaveBanco,			Par_PazaBanxico,		Par_SucursalID,		Par_TipoCta,
						Par_BenefAppPaterno,		Par_BenefAppMaterno,	TRIM(Par_BenefNombre), 	Par_BenefDireccion,	Par_BenefCiudad,
						Par_Estatus,				Par_DesEstatus,			Par_FechaRegistro,		Aud_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
		END IF;
		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Operacion Realizada Exitosamente.');
		SET Var_Control := Cadena_Vacia;
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$