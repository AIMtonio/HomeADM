-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNAGARANTIASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGNAGARANTIASALT`;

DELIMITER $$
CREATE PROCEDURE `ASIGNAGARANTIASALT`(
	/* SP PARA EL ALTA DE ASIGNACION E GARANTIAS */
    Par_SolCredID       	INT(11),			-- Solicitud de credito
    Par_CreditoID       	BIGINT(12),			-- Numero del credito
    Par_GarantiaID      	INT(11),			-- Numero de la garantia
    Par_MontoAsignado   	DECIMAL(14,2),		-- Monto asignado
	Par_Estatus      		CHAR(1),			-- Estatus de Garantia A.- Asignada U.- Autorizada

	Par_EstatusSolicitud	CHAR(1),			-- Estatus de la Solicitud O: Origen(Reestrucuta)N: Nuevo(Solicitud Renovacion)
    Par_SustituyeGL			CHAR(1),			-- Indica si sustituye a la GL

    Par_Salida				CHAR(1),
    INOUT Par_NumErr		INT(11),
    INOUT Par_ErrMen		VARCHAR(400),

    Par_EmpresaID       	INT(11),			-- Auditoria
    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria
    Aud_NumTransaccion  	BIGINT(20)			-- Auditoria
)
TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_FecReg      DATETIME;			-- fecha de registro
    DECLARE Var_Control		VARCHAR(50);		-- Variable de control
    DECLARE Var_Consecutivo	VARCHAR(20);		-- Numero consecutivo
	DECLARE Var_nombreCl	VARCHAR(200);		-- Nombre de cliente
    DECLARE Var_Cliente		BIGINT(12);			-- ID del cliente

	DECLARE Var_MontoGarHip	DECIMAL(14,2);		-- Indica el monto de las garantias que estan libres de gravamen
	DECLARE Var_CliProEsp 	INT(11);			-- Indica el Cliente Especifico
	DECLARE Var_CreditoRelacionado	BIGINT(12);	-- Credito Relacionado a la solicitud
    DECLARE Var_TipoCredito	CHAR(1);			-- Tipo de Solicitud de Credito

	/* Declaracion de Constantes */
    DECLARE Var_MontOrig	DECIMAL(16,2);		-- Monto original
    DECLARE Var_Prendaria	DECIMAL(16,2);		-- Es Prendaria
    DECLARE Var_Hipotecaria	DECIMAL(16,2);		-- Es hipotecaria
    DECLARE Var_MontoAvaluo	DECIMAL(21,2);		-- Monto de Avaluo
    DECLARE Var_MontoMayor	DECIMAL(21,2);		-- Monto mayor de asignacion

    DECLARE Var_NumeroAvaluo 	VARCHAR(10);	-- Numero del avaluo
	DECLARE Entero_Cero     INT;				-- Entero vacio
	DECLARE Decimal_Cero    INT;				-- decimal vacio
	DECLARE Msg_Autorizado  VARCHAR(70);		-- Mensaje de no autorizado
	DECLARE Msg_Asignado	VARCHAR(70);		-- Mensaje de asignado

	DECLARE Est_Autorizado  CHAR(1);			-- Estatus de Garantia Autorizada
    DECLARE Salida_SI		CHAR(1);
	DECLARE Salida_NO		CHAR(1);
    DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Gar_Pren		INT(12);

    DECLARE Gar_Hipo		INT(12);
    DECLARE Fecha_Avaluo	DATE;
	DECLARE LibreGravamen	CHAR(1);
    DECLARE Monto_Garantia 	DECIMAL(14,2);
    DECLARE Monto_Asignado 	DECIMAL (14,2);

    DECLARE Monto_Disponible DECIMAL (14,2);
    DECLARE Est_Nueva		CHAR(1);			-- Estatus de Garantia Nueva
    DECLARE Est_Origen		CHAR(1);			-- Estatus de Garantia Origen



	-- Declaracion de Consultas
	DECLARE Con_MontoDisponGar 	INT(11);		-- Consulta Monto Disponible de Garantia
	DECLARE Con_MontoAvaluo 	INT(11);		-- Consulta Monto de Avaluo de la Garantia
	DECLARE Con_MontoAsignado 	INT(11);		-- Consulta Monto Asignado de la Garantia
	DECLARE CliEspecTama 	INT(11);
	DECLARE Cons_TipoGravemen	CHAR(1);
	
	/* Asignacion de Constantes */
	SET Entero_Cero     := 0;
	SET Decimal_Cero    := 0.00;
	SET Msg_Autorizado	:= 'La Asignacion de Garantias se ha Grabado Exitosamente';
	SET Msg_Asignado	:= 'Las Garantias fueron Asignadas';
	SET Est_Autorizado  := 'U';
    SET Salida_SI		:='S';
	SET Salida_NO		:= 'N';		
    SET Cadena_Vacia	:='';
    SET Gar_Pren		:= 2;
    SET Gar_Hipo		:= 3;
	SET LibreGravamen	:= 'L';		
	SET Monto_Garantia	:= 0.00;
	SET Est_Nueva		:= 'N';
	SET Est_Origen		:= 'O';

	-- Asignacion de Consultas
	SET Con_MontoDisponGar		:= 1;
	SET Con_MontoAvaluo			:= 2;
	SET Con_MontoAsignado		:= 3;
	SET CliEspecTama	:= 28;	
	SET Cons_TipoGravemen	:= 'G';
	
	SET Var_FecReg  := NOW();
	SET Par_EstatusSolicitud := IFNULL(Par_EstatusSolicitud, Est_Nueva);

    ManejoErrores:BEGIN

    	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-ASIGNAGARANTIASALT');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		IF(IFNULL(Par_GarantiaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr :=	1;
			SET Par_ErrMen := 	'La Garatia no Existe';
			SET Var_Control	:= 'garantiaID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MontoAsignado, Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr :=	2;
			SET Par_ErrMen := 	'El Monto Asignado debe ser mayor a cero';
			SET Var_Control	:= 'montoAsignado';
			LEAVE ManejoErrores;
		END IF;

		SELECT ValorParametro
		INTO Var_CliProEsp
			FROM PARAMGENERALES
			WHERE LlaveParametro= 'CliProcEspecifico';

		IF(Var_CliProEsp = CliEspecTama) THEN
			SELECT IF(TipoGravemen = Cons_TipoGravemen, MontoGravemen,MontoAvaluo)-- AJuste rlavida_13456
			INTO Monto_Garantia
            FROM GARANTIAS where GarantiaID= Par_GarantiaID;
		ELSE
			SELECT MontoAvaluo
			INTO Monto_Garantia
            FROM GARANTIAS where GarantiaID= Par_GarantiaID;
        END IF;

        SET Monto_Garantia := IFNULL(Monto_Garantia,Decimal_Cero);

		SELECT  IFNULL(sum(Asig.MontoAsignado),0) As MontoAsignado
		INTO Monto_Asignado
			FROM ASIGNAGARANTIAS Asig
				INNER JOIN CREDITOS Cre  on Asig.CreditoID = Cre.CreditoID
			WHERE Asig.GarantiaID= Par_GarantiaID and (Cre.Estatus = 'V' or Cre.CreditoID= 'B');
			
        SET Monto_Asignado := IFNULL(Monto_Asignado,Decimal_Cero);

		SET Monto_Disponible := Monto_Garantia - Monto_Asignado;
		SET Monto_Disponible := IFNULL(Monto_Disponible,Decimal_Cero);


		If(Par_MontoAsignado > Monto_Disponible) THEN
       		SET Par_NumErr :=	3;
			SET Par_ErrMen := 	'La Garantia Asignada No Cuenta Con Monto Suficiente.';
			SET Var_Control	:= 'garantiaID';
			LEAVE ManejoErrores;
        END IF;





		INSERT INTO ASIGNAGARANTIAS(
			SolicitudCreditoID, CreditoID,  			GarantiaID, 		MontoAsignado,  	FechaRegistro,
			Estatus,            EstatusSolicitud,		SustituyeGL,
			EmpresaID,			Usuario,				FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion)
		VALUES(
			Par_SolCredID,  	Par_CreditoID,  		Par_GarantiaID, 	Par_MontoAsignado,  Var_FecReg,
			Par_Estatus,     	Par_EstatusSolicitud,	Par_SustituyeGL,
			Par_EmpresaID,  	Aud_Usuario,    		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,   	Aud_NumTransaccion);

		IF( Par_Estatus = Est_Autorizado) THEN

			SELECT  CL.NombreCompleto INTO Var_nombreCl
				FROM SOLICITUDCREDITO SOL
				INNER JOIN CLIENTES CL ON SOL.ClienteID  = CL.ClienteID
				WHERE SOL.SolicitudCreditoID = Par_SolCredID;

			SET Var_nombreCl = IFNULL(Var_nombreCl,Cadena_Vacia );

			IF(Var_nombreCl = Cadena_Vacia) THEN

				SELECT  Pro.NombreCompleto  INTO Var_nombreCl
					FROM SOLICITUDCREDITO SOL
					INNER JOIN PROSPECTOS Pro ON SOL.ProspectoID  = Pro.ProspectoID
					WHERE SOL.SolicitudCreditoID=Par_SolCredID;

	        END IF;

			SELECT CL.ClienteID, CL.NombreCompleto, SOL.MontoSolici INTO Var_Cliente, Var_nombreCl, Var_MontOrig
			FROM SOLICITUDCREDITO SOL
				INNER JOIN CLIENTES CL ON SOL.ClienteID=CL.ClienteID
			WHERE SOL.SolicitudCreditoID=Par_SolCredID;

			 IF (IFNULL(Var_Cliente,Entero_Cero) = 0) THEN
					SELECT  Pro.ProspectoID  INTO Var_Cliente
					FROM SOLICITUDCREDITO SOL
					INNER JOIN PROSPECTOS Pro ON SOL.ProspectoID  = Pro.ProspectoID
					WHERE SOL.SolicitudCreditoID=Par_SolCredID;
	            END IF;

			SET Var_Cliente = IFNULL(Var_Cliente,Entero_Cero);
	        SET Var_nombreCl = IFNULL(Var_nombreCl,Cadena_Vacia);
	        SET Var_MontOrig = IFNULL(Var_MontOrig,Decimal_Cero);


			SELECT  CASE WHEN G.TipoGarantiaID = Gar_Pren   THEN  Par_MontoAsignado
								ELSE    Decimal_Cero END,
					CASE WHEN G.TipoGarantiaID = Gar_Hipo   THEN  Par_MontoAsignado
								ELSE    Decimal_Cero END,
					FechaValuacion,
					 MontoAvaluo,
					 NumAvaluo,
					 CASE WHEN G.TipoGarantiaID = Gar_Hipo AND G.TipoGravemen = LibreGravamen THEN Par_MontoAsignado
						ELSE Decimal_Cero
					END
				 INTO 	Var_Prendaria,		Var_Hipotecaria,	Fecha_Avaluo ,
						Var_MontoAvaluo,	Var_NumeroAvaluo,	Var_MontoGarHip
			FROM    GARANTIAS G
			WHERE   G.GarantiaID     = Par_GarantiaID;

	        -- Numero de avaluo del que tiene mas asignado
	        SELECT MAX(MontoAsignado) AS Mayor
	        INTO Var_MontoMayor
	        FROM ASIGNAGARANTIAS Asi
			WHERE SolicitudCreditoID = Par_SolCredID LIMIT 1;

			SELECT Gar.NumAvaluo
	        INTO Var_NumeroAvaluo
	        FROM ASIGNAGARANTIAS Asi, GARANTIAS Gar
	        WHERE Asi.GarantiaID 		 = Gar.GarantiaID
			AND   Asi.SolicitudCreditoID = Par_SolCredID
			AND   Asi.MontoAsignado 	 = Var_MontoMayor LIMIT 1;


			IF EXISTS ( SELECT	 SolicitudCreditoID
						FROM	 CREGARPRENHIPO
	                    WHERE	 SolicitudCreditoID=Par_SolCredID) THEN

				UPDATE 	CREGARPRENHIPO SET
						GarPrendaria	=	GarPrendaria	+	Var_Prendaria,
	                    GarHipotecaria	=	GarHipotecaria	+	Var_Hipotecaria,
	                    MontoAvaluo		=   MontoAvaluo		+   Var_MontoAvaluo,
						 NumeroAvaluo = Var_NumeroAvaluo,
						 MontoGarHipo 	= 	MontoGarHipo 	+ Var_MontoGarHip
				WHERE 	SolicitudCreditoID= Par_SolCredID;

			ELSE
				CALL `CREGARPRENHIPOALT`(
					Var_nombreCl,		Var_MontOrig,		Var_Prendaria,		Var_Hipotecaria,	Fecha_Avaluo,
					Var_Cliente,		Par_SolCredID,		Var_MontoAvaluo,	Var_NumeroAvaluo,	Var_MontoGarHip,
					Par_Salida,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID, 		Aud_Usuario,
					Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal, 		Aud_NumTransaccion);

				IF(Par_NumErr <>Entero_Cero )THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CASE WHEN Par_Estatus = Est_Autorizado THEN Msg_Autorizado ELSE Msg_Asignado	END;
		SET Var_Control	:= 'solicitudCreditoID';
		SET Var_Consecutivo:= Par_SolCredID;

    END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;

END TerminaStore$$
