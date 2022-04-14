DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGAMASIVADISPALT`;
DELIMITER $$

CREATE PROCEDURE `CARGAMASIVADISPALT`(
	Par_FechaOperacion		DATETIME,
	Par_InstitucionID		INT(11),
	Par_NumCtaInstit 		VARCHAR(20),
	Par_CuentaAho			INT(11),
	Par_RutaArchivo			VARCHAR(300),
	Par_Estatus				CHAR(1),

    Par_Salida 				CHAR(1),    
    INOUT	Par_NumErr	 	INT(11),
    INOUT	Par_ErrMen	 	VARCHAR(400),
    
    INOUT Var_FolioSalida   INT(11), 

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),	
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
		)
TerminaStore: BEGIN
	
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT(11);
	DECLARE  Var_FolioOperacion	INT(11);
	DECLARE	SalidaSi 			CHAR(1);
	DECLARE	SalidaNo 			CHAR(1);
	DECLARE	EstatusAbierto		CHAR(1);

	DECLARE Var_Control       	VARCHAR(20);	-- Constante para la variable de control
	DECLARE Var_Institucion		INT(11); 
	DECLARE Var_CtaInstitu		VARCHAR(20); 
    
	
	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero		:= 0;
	SET	SalidaSi 		:= 'S';
	SET	SalidaNo 		:= 'N';	
	SET	EstatusAbierto	:= 'A'; 	


	ManejoErrores:BEGIN
    		DECLARE EXIT HANDLER FOR SQLEXCEPTION
       		 BEGIN
            	SET Par_NumErr = 999;
            	SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					'esto le ocasiona. Ref: SP-CARGAMASIVADISPALT');
            	SET Var_Control  := 'SQLEXCEPTION';
        	END;

		SET Var_Institucion := IFNULL((SELECT InstitucionID
									FROM INSTITUCIONES 
									WHERE InstitucionID= Par_InstitucionID ),Entero_Cero);


		IF(IFNULL(Var_Institucion,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'La Institucion especificada no Existe';
			SET Var_Control := 'institucionID';
			LEAVE ManejoErrores;
		END IF;



		SET Var_CtaInstitu := IFNULL((SELECT NumCtaInstit 
								FROM CUENTASAHOTESO 
								WHERE InstitucionID= Par_InstitucionID 
								AND NumCtaInstit= Par_NumCtaInstit),Cadena_Vacia); 

		IF(IFNULL(Var_CtaInstitu,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'La Cuenta Bancaria especificada no Existe';
			SET Var_Control := 'numCtaInstit'; 
			LEAVE ManejoErrores;
		END IF;


		SET Par_CuentaAho:= IFNULL((SELECT CuentaAhoID 
							FROM CUENTASAHOTESO 
							WHERE InstitucionID= Par_InstitucionID 
							AND NumCtaInstit= Par_NumCtaInstit),Cadena_Vacia); 

		IF(IFNULL(Par_CuentaAho, Entero_Cero))= Entero_Cero THEN

				SET Par_NumErr := 1; 
				SET Par_ErrMen := 'El numero de Cuenta esta vacio.';
				SET Var_Control := 'numCtaInstit'; 
				LEAVE ManejoErrores;
		
		END IF;

		SELECT IFNULL(MAX(DispMasivaID),Entero_Cero)+1 INTO Var_FolioSalida
		FROM CARGAMASIVADISP;

		INSERT INTO CARGAMASIVADISP
			(DispMasivaID, 	FolioOperacion, 	FechaOperacion, InstitucionID, 	CuentaAhoID,
			NumCtaInstit, 	TotalRegistros, 	MontoEnviado, 	RutaArchivo, 	Estatus,
			EmpresaID, 		Usuario, 			FechaActual, 	DireccionIP, 	ProgramaID,
			Sucursal, 		NumTransaccion)
		VALUES
			(Var_FolioSalida,	Entero_Cero,	Par_FechaOperacion, Par_InstitucionID, 	Par_CuentaAho,
			Par_NumCtaInstit,	Entero_Cero,	Entero_Cero,		Par_RutaArchivo,	Par_Estatus,
			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Registro Realizada Exitosamente.');
		SET Var_Control := 'institucionID';
			
	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_FolioSalida AS Consecutivo;
	END IF;
END TerminaStore$$