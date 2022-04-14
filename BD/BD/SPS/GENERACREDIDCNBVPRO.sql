-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERACREDIDCNBVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERACREDIDCNBVPRO`;DELIMITER $$

CREATE PROCEDURE `GENERACREDIDCNBVPRO`(
	/* *******************************************************
    *   Genera el ID del Credito para la CNBV - SOFIPOS
    ********************************************************* */
	Par_InstrumentoID			BIGINT,  -- Identificador del Instrumento Credito o Linea
    Par_TipoProd				INT, 	 -- 1 .- Linea de Credito, 2.- Credito
	Par_Salida					CHAR(1),
    INOUT	Par_NumErr 			INT,
	INOUT	Par_ErrMen  		VARCHAR(400),
    INOUT	Par_CreditoIDCNBV   VARCHAR(29),

    Par_EmpresaID				INT,			-- Auditoria
    Par_Usuario 				INT(11) ,		-- Auditoria
    Par_FechaActual 			DATETIME,		-- Auditoria
    Par_DireccionIP 			VARCHAR(15),	-- Auditoria
    Par_ProgramaID 				VARCHAR(50),	-- Auditoria
    Par_SucursalID 				INT(11) ,		-- Auditoria
    Par_NumTransaccion 			BIGINT(20)		-- Auditoria
)
TerminaStore:BEGIN

DECLARE Var_TipoCredito 	INT;			-- Tipo de Credito
DECLARE Var_Entidad			VARCHAR(6);		-- Clave de la entidad
DECLARE Var_FechaOtorga 	DATE;  			-- Fecha de otorgamiento
DECLARE Var_RFC				VARCHAR(13);  	-- RFC del Cliente
DECLARE Var_Consecutivo 	INT; 			-- Almacena el conscutivo de creditos del cliente
DECLARE Var_TipoCliente 	CHAR(1);		-- F = Fisica, A = Actividad Emrpesarial, M = Moral
DECLARE Var_ClaveEntidad 	VARCHAR(10); 	-- Clave de la Entidad en parametros
DECLARE Var_CreditoIDCNBV 	VARCHAR(50);	-- Identificador CNBV
DECLARE Var_IdentificadorCNBV 	VARCHAR(50);	-- Identificador CNBV
DECLARE Var_ClienteID		INT;			-- ID del Cliente
DECLARE Var_TipoInstitucion INT;			-- Tipo de Institucion para determinar si es SOFIPO
DECLARE Var_NumeroCreditos	INT;			-- Numero de Creditos
DECLARE Var_Disponible		CHAR(1);		-- Indica si el ID CNBV esta disponible
DECLARE Var_Control			VARCHAR(50);	-- Variable de control
DECLARE Var_OrigenCredito	CHAR(1);		-- Origen, nuevo, restructura o renovacion
DECLARE Var_CreditoAnt      BIGINT;			-- ID del Credito anterior

DECLARE Salida_SI 			CHAR(1);
DECLARE Cadena_Vacia		VARCHAR(2);
DECLARE Act_LineaCredito	INT;			-- Actualizar Linea de credito
DECLARE Act_TblCredito		INT;			-- Actualizar Tabla de Credito
DECLARE Tipo_Sofipo			INT;			-- Clave para tipo SOFIPO
DECLARE Tipo_Vivienda		CHAR(1);		-- Clave de Credito tipo Vivienda
DECLARE Tipo_Comercial		CHAR(1);		-- Clave de credito tipo comercial
DECLARE Tipo_Consumo		CHAR(1);		-- Clave de credito tipo Consumo
DECLARE Pers_Moral			CHAR(1);		-- Persona moral
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;
DECLARE Clave_Vivienda		INT;			-- Clave cnbv vivienda
DECLARE Clave_Consumo		INT;			-- Clave cnbv comsuno
DECLARE Clave_Comercial		INT;			-- clave cnbv comercial
DECLARE Es_Reestructura		CHAR(1);			-- clave reestrcutura
DECLARE Es_Renovacion		CHAR(1);			-- clave renovacion



SET Salida_SI	 	 := 'S';
SET Cadena_Vacia	 := '';
SET Act_LineaCredito := 1;
SET Act_TblCredito	 := 2;
SET Tipo_Sofipo		 := 3;
SET Tipo_Vivienda	 := 'H';
SET Tipo_Comercial	 := 'C';
SET Tipo_Consumo	 := 'O';
SET Pers_Moral		 := 'M';
SET Fecha_Vacia		 := '1900-01-01';
SET Entero_Cero		 := 0;
SET Var_Disponible	 := 'N';
SET Clave_Vivienda	 := 1;
SET Clave_Consumo	 := 3;
SET Clave_Comercial	 := 2;
SET	Es_Reestructura	 := 'R';
SET Es_Renovacion	 := 'O';



ManejoErrores:BEGIN

	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-GENERACREDIDCNBVPRO');
			SET Var_Control	:= 'SQLEXCEPTION';
		END;

        /*
        * == Validar que sea una SOFIPO ==
        */
        SELECT Ins.TipoInstitID INTO Var_TipoInstitucion FROM PARAMETROSSIS Par, INSTITUCIONES Ins
			WHERE 	Par.InstitucionID = Ins.InstitucionID
			AND 	Par.EmpresaID = Par_EmpresaID;

        IF IFNULL(Var_TipoInstitucion,Cadena_Vacia) <> Tipo_Sofipo THEN
			SET Par_NumErr := 0;
			SET Par_ErrMen := 'La Institucion no es SOFIPO';
			LEAVE ManejoErrores;
        END IF;


        IF Par_TipoProd = Act_LineaCredito THEN
			SELECT Cre.FechaInicio,
					CASE WHEN Pro.Tipo = Tipo_Vivienda 	THEN Clave_Vivienda
						 WHEN Pro.Tipo = Tipo_Comercial THEN Clave_Comercial
						 WHEN Pro.Tipo = Tipo_Consumo 	THEN Clave_Consumo
					END AS TipoCredito,
					CASE WHEN Cli.TipoPersona = Pers_Moral THEN CONCAT('_',substr(Cli.RFCOficial,1,12)) ELSE  Cli.RFCOficial END AS RFC ,
					Cli.TipoPersona,
					Cli.ClienteID
			 INTO Var_FechaOtorga,Var_TipoCredito, Var_RFC, Var_TipoCliente,Var_ClienteID
			 FROM LINEASCREDITO Cre,CLIENTES Cli, PRODUCTOSCREDITO Pro
				WHERE 	Cre.ClienteID 			= Cli.ClienteID
				AND 	Cre.LineaCreditoID  	= Par_InstrumentoID
				AND 	Cre.ProductoCreditoID 	= Pro.ProducCreditoID;

        END IF;

        IF Par_TipoProd = Act_TblCredito THEN
				SELECT Cre.FechaInicio,
						CASE WHEN Cre.ClasiDestinCred = Tipo_Vivienda 	THEN 1
							 WHEN Cre.ClasiDestinCred = Tipo_Comercial 	THEN 2
							 WHEN Cre.ClasiDestinCred = Tipo_Consumo 	THEN 3
						END AS TipoCredito,
						CASE WHEN Cli.TipoPersona = Pers_Moral THEN CONCAT('_',substr(Cli.RFCOficial,1,12)) ELSE  Cli.RFCOficial END ,
						Cli.TipoPersona,
						Cli.ClienteID
				INTO Var_FechaOtorga,Var_TipoCredito, Var_RFC, Var_TipoCliente,Var_ClienteID
				 FROM CREDITOS Cre,CLIENTES Cli
				WHERE Cre.ClienteID = Cli.ClienteID
				AND Cre.CreditoID  = Par_InstrumentoID;
		END IF;


		SET Var_ClaveEntidad	:= IFNULL((SELECT Par.ClaveEntidad
												FROM PARAMETROSSIS Par
												WHERE Par.EmpresaID = Par_EmpresaID), Cadena_Vacia);

		-- Digitos de control
		IF exists( Select ClienteID FROM CREDITOSCLIENTES
						WHERE ClienteID = Var_ClienteID ) then

			SELECT IFNULL(NumeroCreditos,Entero_Cero) INTO Var_Consecutivo FROM CREDITOSCLIENTES
			WHERE ClienteID = Var_ClienteID;

		else
			select count(CreditoID)
				into Var_Consecutivo
				from CREDITOS
                where ClienteID = Var_ClienteID;

            set Var_Consecutivo := ifnull(Var_Consecutivo,0);

            insert into CREDITOSCLIENTES values(
			Var_ClienteID,		Var_Consecutivo,	Fecha_Vacia,	Par_EmpresaID, 	Par_Usuario,
			Par_FechaActual, 	Par_DireccionIP,	Par_ProgramaID, Par_SucursalID, Par_NumTransaccion );

		end if;

		SET Var_Consecutivo := IFNULL(Var_Consecutivo,Entero_Cero)  + 1;


		IF IFNULL(Var_FechaOtorga,Fecha_Vacia) = Fecha_Vacia THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Fecha de Otorgamiento Vacia';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Var_TipoCredito,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'Destino de Credito Vacia';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Var_RFC,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'RFC Oficial Vacio';
			LEAVE ManejoErrores;
		END IF;


		IF length(IFNULL(Var_RFC,Cadena_Vacia)) < 13 THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'RFC Incompleto';
			LEAVE ManejoErrores;
		END IF;

		IF length(IFNULL(Var_ClaveEntidad,Cadena_Vacia)) <> 6 THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := 'Clave de Entidad Incompleta';
			LEAVE ManejoErrores;
		END IF;

        IF Var_Consecutivo >= 999 THEN
			SET Var_Consecutivo :=  1;
        END IF;



        SET Par_CreditoIDCNBV := CONCAT(IFNULL(Var_TipoCredito,Cadena_Vacia),
								 IFNULL(Var_ClaveEntidad,Cadena_Vacia),
								 date_format(IFNULL(Var_FechaOtorga,Fecha_Vacia),'%Y%m'),
                                 IFNULL(Var_RFC,Cadena_Vacia),
                                 lpad(IFNULL(Var_Consecutivo,Cadena_Vacia),3,Entero_Cero));



        IF EXISTS ( SELECT IdenCreditoCNBV FROM CREDITOS WHERE IdenCreditoCNBV = Par_CreditoIDCNBV) THEN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('Identificador Credito CNBV Duplicado: ',Par_CreditoIDCNBV);
			LEAVE ManejoErrores;
        END IF;

        IF EXISTS ( SELECT IdenCreditoCNBV FROM LINEASCREDITO WHERE IdenCreditoCNBV = Par_CreditoIDCNBV) THEN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('Identificador Credito CNBV Duplicado: ',Par_CreditoIDCNBV);
			LEAVE ManejoErrores;
        END IF;



		-- Actualizar el Numero de Creditos al Cliente
		UPDATE CREDITOSCLIENTES SET
			NumeroCreditos = Var_Consecutivo,
			FechaUltCre	   = Var_FechaOtorga
		WHERE ClienteID = Var_ClienteID;


        IF Par_TipoProd = Act_LineaCredito THEN
			UPDATE LINEASCREDITO SET
				IdenCreditoCNBV = Par_CreditoIDCNBV
            WHERE LineaCreditoID = Par_InstrumentoID;
        END IF;


        IF Par_TipoProd = Act_TblCredito THEN

			-- ---------------------------------------------------------------------
        --  Validacion para ingresar el mismo numero CNBV cuando se trata de
        --  Una reestructura o renovacion
        -- ---------------------------------------------------------------------
			SELECT TipoCredito, IdenCreditoCNBV, Relacionado
				INTO Var_OrigenCredito, Var_IdentificadorCNBV, Var_CreditoAnt
				FROM CREDITOS
				WHERE CreditoID = Par_InstrumentoID;

            IF IFNULL(Var_OrigenCredito,Cadena_Vacia) = Es_Reestructura
			OR IFNULL(Var_OrigenCredito,Cadena_Vacia) = Es_Renovacion   THEN

				SELECT  IdenCreditoCNBV
				INTO    Var_IdentificadorCNBV
				FROM CREDITOS
				WHERE CreditoID = Var_CreditoAnt;

                SET Par_CreditoIDCNBV := ifnull(Var_IdentificadorCNBV,Par_CreditoIDCNBV);

            END IF;

			-- Actualizamos el ID en la tabla CREDITOS
			UPDATE CREDITOS SET
				IdenCreditoCNBV = Par_CreditoIDCNBV
			WHERE CreditoID = Par_InstrumentoID;
        END IF;


		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Identificador CNBV generado exitosamente';

END ManejoErrores;

IF Par_Salida = Salida_SI  THEN
	SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
            IFNULL(Var_Control,Entero_Cero) AS control,
            Par_CreditoIDCNBV AS consecutivo;

END IF;


END TerminaStore$$