-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEITRANSFERENCIASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEITRANSFERENCIASPRO`;DELIMITER $$

CREATE PROCEDURE `SPEITRANSFERENCIASPRO`(



	Par_SpeiTransID        BIGINT(20),
    Par_CuentaAhoID        BIGINT(12),
    Par_ClienteID          INT(12),
	Par_Monto              DECIMAL(16,2),
	Par_UsuarioAutoriza    INT(11),

	Par_Salida			   CHAR(1),
	INOUT Par_NumErr	   INT,
	INOUT Par_ErrMen	   VARCHAR(350),

	Par_EmpresaID		   INT(11),
	Aud_Usuario			   INT(11),
	Aud_FechaActual		   DATETIME,
	Aud_DireccionIP		   VARCHAR(20),
	Aud_ProgramaID		   VARCHAR(50),
	Aud_Sucursal		   INT(11),
	Aud_NumTransaccion	   BIGINT(20)
	)
TerminaStore: BEGIN


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE	Decimal_Cero		DECIMAL(18,2);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE Salida_SI			CHAR(1);
	DECLARE	Salida_NO			CHAR(1);
	DECLARE Mon_Pesos			INT;
	DECLARE	AltaPoliza_SI		CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE	TipoMovAho_Remesa	INT;
	DECLARE EncPoliza_SI		CHAR(1);
	DECLARE CtoConTra_Rem		INT;
	DECLARE	Con_AhoCapital		INT;
	DECLARE	Act_Autoriza		INT;
	DECLARE Act_Procesado		INT;
	DECLARE Estatus_Reg			CHAR(1);
	DECLARE Estatus_Activa		CHAR(1);
	DECLARE Con_Si				CHAR(1);
	DECLARE Nat_Mov				CHAR(1);
	DECLARE TipoBloq			INT;
	DECLARE Descip				VARCHAR(150);


	DECLARE Var_Control			VARCHAR(200);
	DECLARE Var_Consecutivo		BIGINT(20);
	DECLARE Var_Referencia		VARCHAR(50);
	DECLARE	Var_Poliza			BIGINT;
	DECLARE	Var_DescMov			VARCHAR(150);
	DECLARE Var_CuentaAho		INT(12);
	DECLARE Var_FechaSis		DATE;
	DECLARE	Var_Cargos			DECIMAL(16,2);
	DECLARE	Var_Abonos			DECIMAL(16,2);
	DECLARE Var_Estatus			CHAR(1);
	DECLARE Var_EsBloAuto		CHAR(1);


	SET	Cadena_Vacia	      := '';
	SET	Fecha_Vacia		      := '1900-01-01 00:00:00';
	SET	Entero_Cero		      := 0;
	SET	Decimal_Cero	      := 0.0;
	SET Salida_SI 	   	      := 'S';
	SET	Salida_NO		      := 'N';
	SET	Par_NumErr		      := 0;
	SET	Par_ErrMen		      := '';
	SET Mon_Pesos		      := 1;
	SET	AltaPoliza_SI	      := 'S';
	SET Nat_Abono	          := 'A';
	SET Nat_Cargo	          := 'C';
	SET Var_Poliza		      := 0;
	SET TipoMovAho_Remesa	  := 24;
	SET EncPoliza_SI		  := 'S';
	SET CtoConTra_Rem	      := 814;
	SET	Con_AhoCapital  	  := 1;
	SET Act_Autoriza          := 1;
	SET Act_Procesado         := 2;
	SET Estatus_Reg           := 'P';
	SET Estatus_Activa        := 'A';
	SET Con_Si             	  := 'S';
	SET Nat_Mov 			  := 'B';
	SET TipoBloq			  := 13;
	SET Descip                := 'Bloqueo por recepcion de SPEI';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEITRANSFERENCIASPRO');
				SET Var_Control = 'sqlException';
			END;

		IF(IFNULL(Par_SpeiTransID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:= 'El Folio de la transferencia esta vacio.';
			SET Var_Control	:= 'speiTransID' ;
			LEAVE ManejoErrores;
		END IF;


		SET Var_Estatus := (SELECT	Estatus	FROM	SPEITRANSFERENCIAS	WHERE	SpeiTransID = Par_SpeiTransID);

		IF EXISTS(SELECT	SpeiTransID
				FROM SPEITRANSFERENCIAS
				WHERE	SpeiTransID	= Par_SpeiTransID) THEN

			IF(Var_Estatus = Estatus_Reg) THEN


				SELECT	FechaSistema	INTO	Var_FechaSis
					FROM PARAMETROSSIS;

				SET	Var_DescMov	:= 'TRANSFERENCIA REMESA';


				CALL SPEITRANSFERENCIASACT(
					Par_SpeiTransID,  Par_UsuarioAutoriza,  Aud_NumTransaccion,     Act_Autoriza,        Salida_NO,
					Par_NumErr,       Par_ErrMen,        	Par_EmpresaID,          Aud_Usuario,         Aud_FechaActual,
					Aud_DireccionIP,  Aud_ProgramaID,       Aud_Sucursal,           Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					SET Var_Control		:= 'SpeiTransID' ;
					SET Var_Consecutivo := Par_SpeiTransID;
					LEAVE ManejoErrores;
				END IF;



				SET Var_Referencia 	:= (CONVERT(Par_SpeiTransID,CHAR));
				SET Aud_FechaActual := CURRENT_TIMESTAMP();


				CALL CARGOABONOCUENTAPRO(
					Par_CuentaAhoID, 	Par_ClienteID,		Aud_NumTransaccion, Var_FechaSis, 		Var_FechaSis,
					Nat_Abono,		    Par_Monto,			Var_DescMov, 	    Var_Referencia,		TipoMovAho_Remesa,
					Mon_Pesos,   		Aud_Sucursal, 	    EncPoliza_SI,		CtoConTra_Rem,	    Var_Poliza,
					AltaPoliza_SI, 		Con_AhoCapital,		Nat_Abono,   		Entero_Cero,		Salida_NO,
					Par_NumErr, 		Par_ErrMen, 	    Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					SET Var_Control		:= 'SpeiTransID' ;
					SET Var_Consecutivo := Par_SpeiTransID;
					LEAVE ManejoErrores;
				END IF;


				SELECT	TC.EsBloqueoAuto	INTO	Var_EsBloAuto
					FROM TIPOSCUENTAS TC
						INNER JOIN CUENTASAHO CA ON	CA.TipoCuentaID = TC.TipoCuentaID
					WHERE	CA.CuentaAhoID = Par_CuentaAhoID;

				IF(Var_EsBloAuto = Con_Si) THEN
					CALL BLOQUEOSCUENTAPRO(
						Entero_Cero,	Nat_Mov,			Par_CuentaAhoID,	Var_FechaSis,		Par_Monto,
						Fecha_Vacia,	TipoBloq,			Descip,				Par_SpeiTransID,	Cadena_Vacia,
						Cadena_Vacia,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
						Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						SET Var_Control		:= 'SpeiTransID' ;
						SET Var_Consecutivo := Par_SpeiTransID;
						LEAVE ManejoErrores;
					END IF;
				END IF;


				SET	Var_Cargos	:= Par_Monto;
				SET	Var_Abonos	:= Decimal_Cero;

				CALL POLIZATRANSFERPRO(
					Var_Poliza,			Par_EmpresaID,		Var_FechaSis,	    Par_CuentaAhoID,	Aud_Sucursal,
					Var_Cargos, 		Var_Abonos,			Mon_Pesos,	   	    Var_DescMov,	    Par_SpeiTransID,
					Salida_NO,			Par_NumErr, 		Par_ErrMen,			Entero_Cero,    	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					SET Var_Control		:= 'SpeiTransID' ;
					SET Var_Consecutivo := Par_SpeiTransID;
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_NumErr 	:= 002;
				SET Par_ErrMen 	:= CONCAT('La transferencia con Estatus: ',Var_Estatus, ' no puede ser autorizado');
				SET Var_Control	:= 'speiTransID' ;
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen 	:= CONCAT('La transferencia ',Par_SpeiTransID, ' no Existe');
			SET Var_Control	:= 'speiTransID' ;
			LEAVE ManejoErrores;
		END IF;

        SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= CONCAT('Transferencia ',Par_SpeiTransID,' Autorizada Exitosamente');
		SET Var_Control	:= 'SpeiTransID';

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$