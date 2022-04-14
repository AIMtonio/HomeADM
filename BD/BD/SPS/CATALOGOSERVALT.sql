-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGOSERVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATALOGOSERVALT`;
DELIMITER $$


CREATE PROCEDURE `CATALOGOSERVALT`(



	Par_Origen			CHAR(1),
	Par_NombreServicio	VARCHAR(50),
	Par_RazonSocial		VARCHAR(150),
	Par_Direccion		VARCHAR(500),
	Par_CobraComision	CHAR(1),

	Par_MontoComision	DECIMAL(14,4),
	Par_CtaContaCom		VARCHAR(25),
	Par_CtaContaIVACom	VARCHAR(25),
	Par_CtaPagarProv	VARCHAR(25),
	Par_MontoServicio	DECIMAL(15,4),

	Par_CtaContaServ	VARCHAR(25),
	Par_CtaContaIVAServ	VARCHAR(25),
	Par_RequiereCliente	CHAR(1),
	Par_RequiereCredito	CHAR(1),
	Par_BancaElect		CHAR(1),

	Par_PagoAutomatico	CHAR(1),
	Par_CuentaClabe		CHAR(18),
	Par_CentoCostos		VARCHAR(30),
    Par_Ventanilla		CHAR(1),
    Par_BancaMovil		CHAR(1),

    Par_NumServProve	INT(11),

	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
		)

TerminaStore: BEGIN


	DECLARE Var_CatalogoSerID		INT(11);
	DECLARE Var_CuentaComision		VARCHAR(25);
	DECLARE Var_CuentaIVAComision	VARCHAR(25);
	DECLARE Var_CuentaPagarProv		VARCHAR(25);
	DECLARE Var_Control				VARCHAR(45);
	DECLARE Var_CuentaServicio		VARCHAR(25);
	DECLARE Var_CuentaIVAServicio	VARCHAR(25);
	DECLARE Var_BancaElect			CHAR(1);


	DECLARE SalidaSI		CHAR(1);
	DECLARE Cadena_Vacia	CHAR;
	DECLARE SI				CHAR(1);
	DECLARE OrigenTercero	CHAR(1);
	DECLARE OrigenInterno	CHAR(1);
	DECLARE Decimal_Cero	DECIMAL;
	DECLARE Entero_Cero		INT;
    DECLARE Estatus_Activo	CHAR(1);



	SET SalidaSI			:= 'S';
	SET Cadena_Vacia		:= '';
	SET SI					:= 'S';
	SET OrigenTercero		:= 'T';
	SET OrigenInterno		:= 'I';
	SET Decimal_Cero		:= 0.0;
	SET Entero_Cero			:= 0;
	SET Var_BancaElect		:= '';
	SET Estatus_Activo		:= 'A';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CATALOGOSERVALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		IF(Par_Origen = Cadena_Vacia) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Indique el Origen del Servicio';
			SET Var_Control := 'origen1';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NombreServicio = Cadena_Vacia) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'Ingrese el Nombre del Servicio';
			SET Var_Control := 'nombreServicio';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_RequiereCredito = SI AND Par_RequiereCliente = Cadena_Vacia) THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'Si requiere Credito tambien debe requerir Cliente';
			SET Var_Control := 'requiereCliente1';
			LEAVE ManejoErrores;
		END IF;


		IF(Par_Origen = OrigenTercero) THEN
			IF(Par_CobraComision = SI ) THEN
				IF(Par_MontoComision = Decimal_Cero) THEN
					SET Par_NumErr  := 004;
					SET Par_ErrMen  := 'Indique el Monto de la Comision';
					SET Var_Control := 'montoComision';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_CtaContaCom = Cadena_Vacia) THEN
					SET Par_NumErr  := 005;
					SET Par_ErrMen  := 'Indique la cuenta Contable de la Comision';
					SET Var_Control := 'ctaContaCom';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_CtaContaIVACom = Cadena_Vacia) THEN
					SET Par_NumErr  := 006;
					SET Par_ErrMen  := 'Indique la cuenta Contable del IVA de la Comision';
					SET Var_Control := 'ctaContaIVACom';
					LEAVE ManejoErrores;
				END IF;

				SET Var_CuentaComision := (SELECT CuentaCompleta
											 FROM CUENTASCONTABLES
											WHERE	CuentaCompleta	= Par_CtaContaCom);

				IF(IFNULL( Var_CuentaComision, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr  := 011;
					SET Par_ErrMen  := 'El numero de Cuenta Contable indicada para la Comision  no Existe';
					SET Var_Control :='ctaContaCom';
					LEAVE ManejoErrores;
				END IF;

				SET Var_CuentaIVAComision := (SELECT CuentaCompleta
												FROM CUENTASCONTABLES
											   WHERE	CuentaCompleta	= Par_CtaContaIVACom);

				IF(IFNULL( Var_CuentaIVAComision, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr  := 012;
					SET Par_ErrMen  := 'El numero de Cuenta Contable indicada para el IVA de la Comision  no Existe';
					SET Var_Control := 'ctaContaIVACom';
					LEAVE ManejoErrores;
				END IF;

				SET Var_CuentaPagarProv := (SELECT CuentaCompleta
											  FROM CUENTASCONTABLES
											 WHERE	CuentaCompleta	= Par_CtaPagarProv);

				IF(IFNULL( Var_CuentaPagarProv, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr  := 013;
					SET Par_ErrMen  := 'El numero de Cuenta Contable indicada para el pago al proveedor  no Existe';
					SET Var_Control := 'ctaPagarProv';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_CtaPagarProv = Cadena_Vacia) THEN
				SET Par_NumErr  := 007;
				SET Par_ErrMen  := 'Indique la cuenta Contable por pagar del Proveedor';
				SET Var_Control :='ctaPagarProv';
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF(Par_Origen = OrigenInterno) THEN
			IF(Par_MontoServicio = Decimal_Cero) THEN
				SET Par_NumErr  := 008;
				SET Par_ErrMen  := 'Indique el Monto del servicio';
				SET Var_Control := 'montoServicio';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_CtaContaServ = Cadena_Vacia) THEN
				SET Par_NumErr  := 009;
				SET Par_ErrMen  := 'Indique la cuenta contable del monto del servicio';
				SET Var_Control :='ctaContaServ';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_CtaContaIVAServ = Cadena_Vacia) THEN
				SET Par_NumErr  := 010;
				SET Par_ErrMen  := 'Indique la cuenta contable del IVA del monto del servicio';
				SET Var_Control := 'ctaContaIVAServ';
				LEAVE ManejoErrores;
			END IF;

			SET Var_CuentaServicio := (SELECT CuentaCompleta
										 FROM CUENTASCONTABLES
										WHERE	CuentaCompleta	= Par_CtaContaServ);

			IF(IFNULL( Var_CuentaServicio, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 014;
				SET Par_ErrMen  := 'El numero de Cuenta Contable indicada para el Servicio no Existe';
				SET Var_Control := 'ctaContaServ';
				LEAVE ManejoErrores;
			END IF;

			SET Var_CuentaIVAServicio := (SELECT CuentaCompleta
											FROM CUENTASCONTABLES
										   WHERE	CuentaCompleta = Par_CtaContaIVAServ);

			IF(IFNULL( Var_CuentaIVAServicio, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 015;
				SET Par_ErrMen  := 'El numero de Cuenta Contable indicada para el IVA del Servicio no Existe';
				SET Var_Control := 'ctaContaIVAServ';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Var_BancaElect := IFNULL(Par_BancaElect,Cadena_Vacia);
        SET Par_Ventanilla := IFNULL(Par_Ventanilla,Cadena_Vacia);
        SET Par_BancaMovil := IFNULL(Par_BancaMovil,Cadena_Vacia);

		CALL FOLIOSAPLICAACT('CATALOGOSERV', Var_CatalogoSerID);

		INSERT INTO CATALOGOSERV(
			CatalogoServID,		Origen,			NombreServicio,		RazonSocial,		Direccion,
			CobraComision,		MontoComision,	CtaContaCom,		CtaContaIVACom,		CtaPagarProv,
			MontoServicio,		CtaContaServ,	CtaContaIVAServ,	RequiereCliente,	RequiereCredito,
			BancaElect,			PagoAutomatico,	CuentaClabe, 		CCostosServicio,	NumServProve,
            Estatus,			BancaMovil,		Ventanilla,			EmpresaID,			Usuario,
            FechaActual,		DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion)
        VALUES(
			Var_CatalogoSerID,	Par_Origen,			Par_NombreServicio,	Par_RazonSocial,	Par_Direccion,
			Par_CobraComision,	Par_MontoComision,	Par_CtaContaCom,	Par_CtaContaIVACom,	Par_CtaPagarProv,
			Par_MontoServicio,	Par_CtaContaServ,	Par_CtaContaIVAServ,Par_RequiereCliente,Par_RequiereCredito,
			Var_BancaElect,		Par_PagoAutomatico,	Par_CuentaClabe,  	Par_CentoCostos,	Par_NumServProve,
            Estatus_Activo,		Par_BancaMovil,		Par_Ventanilla,		Par_EmpresaID,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT("Servicio ",CONVERT(Var_CatalogoSerID,CHAR), " Agregado correctamente.");
		SET Var_Control	:= 'catalogoServID';

	END ManejoErrores;

		IF (Par_Salida = SalidaSI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_CatalogoSerID AS	consecutivo;
		END IF;

END TerminaStore$$