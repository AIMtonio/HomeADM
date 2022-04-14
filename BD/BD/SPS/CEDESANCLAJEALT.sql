-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESANCLAJEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESANCLAJEALT`;DELIMITER $$

CREATE PROCEDURE `CEDESANCLAJEALT`(
# ===========================================================
# ----------- SP QUE REALIZA LOS ANCLAJES DE CEDES-----------
# ===========================================================
    Par_CedeOriID               INT(11),            -- Numero de Cede original
    Par_CedeAncID               INT(11),            -- Numero de Cede que se esta anclando
    Par_MontoTotal              DECIMAL(14,2),      -- Monto que sumariza la Cede original con la inversion anclada.
    Par_MontoTotalAnclar        DECIMAL(14,2),      -- Monto de la Cede que se esta anclando.
    Par_Plazo                   INT(11),            -- Plazo de la Nueva Inversipon

    Par_Tasa                    DECIMAL(14,4),      -- Tasa que corresponde a la Cede con anclaje
    Par_FechaAnclaje            DATE,               -- Fecha en que se esta anclando la Cede
    Par_UsuarioAncID            INT(11),            -- Usuario que realiza el anclaje
    Par_SucursalAncID           INT(11),            -- Sucursal donde se realiza el anclaje
    Par_CalculoInteres          INT(1),             -- Calculo de Interes

    Par_TasaISR                 DECIMAL(12,4),      -- Tasa ISR
    Par_TasaNeta                DECIMAL(12,4),      -- Tasa Neta
    Par_InteresGenerado         DECIMAL(18,2),      -- InteresGenerado
    Par_InteresRecibir          DECIMAL(18,2),      -- Interes Recibir
    Par_InteresRetener          DECIMAL(18,2),      -- Interes Retener

    Par_TasaBaseID              INT(11),            -- Tasa Base
    Par_SobreTasa               DECIMAL(14,4),      -- Sobre Tasa
    Par_PisoTasa                DECIMAL(14,4),      -- Piso Tasa
    Par_TechoTasa               DECIMAL(14,4),      -- Techo Tasa
    Par_PlazoInvOr              INT(11),            -- Plazo de la inversion madre

    Par_ValorGat                DECIMAL(12,4),      -- GAT
    Par_ValorGatReal            DECIMAL(12,4),      -- GAT REAL
    Par_NuevaTasa               DECIMAL(12,4),      -- Nueva TASA Neta
    Par_NuevoIntGen             DECIMAL(18,2),      -- Interes Ajustado a la Inversion Madre
    Par_NuevoIntReci            DECIMAL(18,2),      -- Interes Ajustado a la Inversion Madre

    Par_TotalRecibir            DECIMAL(18,2),      -- Total a Recibir

    Par_Salida                  CHAR(1),            -- Salida en Pantalla
    INOUT   Par_NumErr          INT(11),                 -- Salida en Pantalla Numero  de Error o Exito
    INOUT   Par_ErrMen          VARCHAR(400),       -- Salida en Pantalla Mensaje de Error o Exito

	Par_EmpresaID               INT(11),            -- AUDITORIA
    Aud_Usuario                 INT(11),            -- AUDITORIA
    Aud_FechaActual             DATETIME,           -- AUDITORIA
    Aud_DireccionIP             VARCHAR(15),        -- AUDITORIA
    Aud_ProgramaID              VARCHAR(50),        -- AUDITORIA
    Aud_Sucursal                INT(11),            -- AUDITORIA
    Aud_NumTransaccion          BIGINT(20)          -- AUDITORIA
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero             INT;
	DECLARE Entero_Uno              INT;
	DECLARE Fecha_Vacia             DATE;
	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Decimal_Cero            DECIMAL(12,2);
	DECLARE Bloqueado               CHAR(1);
	DECLARE Cancelado               CHAR(1);
	DECLARE Var_TasaISR             DECIMAL(14,4);
	DECLARE Salida_SI               CHAR(1);
	DECLARE Salida_NO               CHAR(1);
	DECLARE TasaFija                CHAR(1);
	DECLARE SabDom                  CHAR(2);            /*Dia Inhabil: Sabado y Domingo */
	DECLARE No_DiaHabil             CHAR(1);            /* No es dia habil */
	DECLARE Est_Act                 CHAR(1);

	-- DECLARACION DE VARIABLES
	DECLARE Var_Estatus             CHAR(1);
	DECLARE Var_CuentaAho           BIGINT(12);
	DECLARE Var_Cliente             INT(11);
	DECLARE Var_TipCede             INT(11);
	DECLARE Var_FechaIni            DATE;
	DECLARE Var_FechaVen            DATE;
	DECLARE VarFechaSistema         DATE;
	DECLARE Var_Plazo               INT(11);
	DECLARE Var_EstatusCede         CHAR(1);
	DECLARE Var_MonedaID            INT(11);
	DECLARE Var_CedeAncID           INT;
	DECLARE Var_CedeAnclajeID       INT;
	DECLARE Var_SaldoProv           DECIMAL(18,2);
	DECLARE Var_MinimoAnclaje       DECIMAL(18,2);
	DECLARE Var_TipoTasa            CHAR(1);
	DECLARE Var_Variable            CHAR(1);
	DECLARE Var_Anclaje             CHAR(1);
	DECLARE Var_TasaMejorada        CHAR(1);
	DECLARE Var_EspTasa             CHAR(1);
	DECLARE Var_Monto               DECIMAL(12,2);
	DECLARE Var_TipoPagoInt         CHAR(1);
	DECLARE Var_DiasBase            INT;
	DECLARE Var_Reinversion         CHAR(1);
	DECLARE Var_Reinvertir          CHAR(3);
	DECLARE Var_CedeRenovada        INT(11);
	DECLARE Var_IntGeneOri          DECIMAL(18,2);
	DECLARE Var_IntReciOri          DECIMAL(18,2);
	DECLARE Var_TasaOri             DECIMAL(14,4);
	DECLARE Var_TasaBaseOri         INT(11);
	DECLARE Var_SobreTasaOri        DECIMAL(14,4);
	DECLARE Var_PisoTasaOri         DECIMAL(14,4);
	DECLARE Var_TechoTasaOri        DECIMAL(14,4);
	DECLARE Var_CalIntOri           INT(11);
	DECLARE Var_ValorGatOri         DECIMAL(14,2);
	DECLARE Var_ValGatRealOri       DECIMAL(14,2);
	DECLARE Var_TasaNetaOri         DECIMAL(14,4);
	DECLARE Var_Control             VARCHAR(50);
	DECLARE ContanteDOS             INT(11);
	DECLARE Var_Anclajes            INT(11);
	DECLARE Var_CajaRetiro			INT(11);
	DECLARE Var_DiaInhabil          CHAR(2);            -- Almacena el Dia Inhabil
	DECLARE Var_FecSal              DATE;               -- Almacena la Fecha de Salida
	DECLARE Var_EsHabil             CHAR(1);            -- Almacena si el dia es habil o no
    DECLARE Var_DiasPeriodo         INT(11);			-- Almacena los dias por periodo de cedes
	DECLARE Var_PagoIntCal			CHAR(2);			-- Almacena el tipo de pago de interes D-Devengado, I - Iguales

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero                 :=  0;              -- Valor Entero Cero
	SET Entero_Uno                  :=  1;              -- Valor Entero Uno
	SET Cadena_Vacia                := '';              -- Cadena o String Vacio
	SET Decimal_Cero                :=  0.00;           -- Valor DECIMAL Cero
	SET Fecha_Vacia                 := '1900-01-01';    -- Fecha Vacia
	SET Var_TasaISR                 :=  0.00;           -- Valor TASA ISR
	SET Var_SaldoProv               :=  0.00;           -- Valor Saldo Provision
	SET Bloqueado                   := 'B';             -- INDICA UN ESTATUS BLOQUEADO
	SET Cancelado                   := 'C';             -- INDICA UN ESTATUS CANCELADO
	SET TasaFija                    := 'F';             -- TASA FIJA
	SET Salida_SI                   := 'S';             -- INDICA QUE  HAY UNA SALIDA
	SET Salida_NO                   := 'N';             -- INDICA QUE  NO HAY UNA SALIDA
	SET Var_Variable                := 'V';             -- Valor Tasa Variable
	SET Aud_FechaActual             := NOW();           -- Fecha Actual
	SET Var_CedeAncID               :=  0;              -- Valor Cede Anclada
	SET ContanteDOS                 :=  2;              -- Valor Alta Anclaje
	SET SabDom                      := 'SD';            -- Dia Inhabil: Sabado y Domingo
	SET No_DiaHabil                 := 'N';             -- No es dia habil
	SET Est_Act                     := 'A';             -- Estatus ACTIVO

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-CEDESANCLAJEALT');
				SET Var_Control ='SQLEXCEPTION';
		END;

		-- OBTENIENDO LA TASA ISR, FECHA Y DIAS DE INVERSION DE PARAMETROS DEL SISTEMA
		SELECT  TasaISR,        FechaSistema,       DiasInversion
		 INTO   Var_TasaISR,    VarFechaSistema,    Var_DiasBase
			FROM PARAMETROSSIS;

		-- OBTENIENDO LOS DATOS DE LA CEDE MADRE
		SELECT  cede.CuentaAhoID,       cede.ClienteID,     cede.TipoCedeID,        cede.FechaInicio,       cede.FechaVencimiento,
				cede.Plazo,             cede.Estatus,       cede.Reinvertir,        cede.CedeRenovada,      cede.MonedaID,
				cede.SaldoProvision,    cede.Monto,         cede.Reinversion,       cede.InteresGenerado,   cede.InteresRecibir,
				cede.TasaFija,          cede.TasaBase,      cede.SobreTasa,         cede.PisoTasa,          cede.TechoTasa,
				cede.CalculoInteres,    cede.ValorGat,      cede.ValorGatReal,      cede.TasaNeta,          cede.TipoPagoInt,
				cede.CajaRetiro,		cede.DiasPeriodo,	cede.PagoIntCal
		 INTO   Var_CuentaAho,          Var_Cliente,        Var_TipCede,            Var_FechaIni,           Var_FechaVen,
				Var_Plazo,              Var_EstatusCede,    Var_Reinvertir,         Var_CedeRenovada,       Var_MonedaID,
				Var_SaldoProv,          Var_Monto,          Var_Reinversion,        Var_IntGeneOri,         Var_IntReciOri,
				Var_TasaOri,            Var_TasaBaseOri,    Var_SobreTasaOri,       Var_PisoTasaOri,        Var_TechoTasaOri,
				Var_CalIntOri,          Var_ValorGatOri,    Var_ValGatRealOri,      Var_TasaNetaOri,        Var_TipoPagoInt,
				Var_CajaRetiro,			Var_DiasPeriodo,	Var_PagoIntCal
		   FROM  CEDES cede
			WHERE cede.CedeID = Par_CedeOriID;

		-- OBTENIENDO LOS DATOS DEL TIPO CEDE MADRE
		SELECT  	Anclaje,        TasaMejorada,       EspecificaTasa,     TasaFV,         MontoMinimoAnclaje,
					DiaInhabil
			INTO  	Var_Anclaje,    Var_TasaMejorada,   Var_EspTasa,        Var_TipoTasa,   Var_MinimoAnclaje,
					Var_DiaInhabil
			FROM 	TIPOSCEDES
			WHERE 	TipoCedeID = Var_TipCede;

		-- VERIFICANDO DIAS INHABILES SABADO Y DOMINGO
		IF(Var_DiaInhabil = SabDom)THEN
			CALL DIASFESTIVOSABDOMCAL(
			VarFechaSistema,    Entero_Cero,        Var_FecSal,         Var_EsHabil,        Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion  );
		END IF;

		IF (IFNULL(Par_UsuarioAncID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  :=  1;
			SET Par_ErrMen  :=  'El Usuario se Encuentra Vacio';
			SET Var_Control :=  'usuarioAncID';
			LEAVE ManejoErrores;
		END IF;

		-- VERIFICANDO EL ESTATUS DEL CLIENTE
		SELECT  Estatus
			INTO    Var_Estatus
			FROM 	USUARIOS
			WHERE 	UsuarioID = Par_UsuarioAncID;

		IF(Var_Estatus = Bloqueado || Var_Estatus = Cancelado) THEN
			SET Par_NumErr  :=  2;
			SET Par_ErrMen  :=  'El Usuario se Encuentra Inactivo';
			SET Var_Control :=  '';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CedeOriID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  :=  3;
			SET Par_ErrMen  :=  'El CEDE Madre se Encuentra Vacio';
			SET Var_Control :=  'cedeOriID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MontoTotal,Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr  :=  4;
			SET Par_ErrMen  :=  'El Monto Conjunto se Encuentra Vacio';
			SET Var_Control :=  'montoTotal';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MontoTotalAnclar,Decimal_Cero) < Var_MinimoAnclaje) THEN
			SET Par_NumErr  :=  5;
			SET Par_ErrMen  :=  CONCAT('El Monto Minimo de Contratacion para el anclaje de un CEDE es: ', FORMAT(Var_MinimoAnclaje,2));
			SET Var_Control :=  'montoAnclar';
		END IF;

		IF(IFNULL(Par_Tasa,Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr  :=  6;
			SET Par_ErrMen  :=  'La Tasa esta Vacia';
			SET Var_Control :=  'montoAnclar';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaAnclaje,Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr  :=  7;
			SET Par_ErrMen  :=  'La Fecha de Inicio esta Vacia';
			SET Var_Control :=  '';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_SucursalAncID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  :=  8;
			SET Par_ErrMen  :=  'La Sucursal esta Vacia.';
		END IF;


		IF (VarFechaSistema != Par_FechaAnclaje) THEN
			SET Par_NumErr  :=  9;
			SET Par_ErrMen  :=  CONCAT('La Fecha de Inicio ', Par_FechaAnclaje, ' es Incorrecta');
			SET Var_Control :=  'fechaInicio';
			LEAVE ManejoErrores;
		END IF;

		IF (DATEDIFF(Var_FechaVen, VarFechaSistema) < Entero_Cero) THEN
			SET Par_NumErr  :=  10;
			SET Par_ErrMen  :=  'El Plazo es Incorrecto';
			SET Var_Control :=  '';
			LEAVE ManejoErrores;
		END IF;

		-- VALIDACIONES TASA VARIABLE
		IF(Var_TipoTasa = Var_Variable) THEN

			IF(IFNULL(Par_TasaBaseID,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr  :=  11;
				SET Par_ErrMen  :=  'La Tasa Base esta Vacia';
				SET Var_Control :=  'montoAnclar';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CalculoInteres,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr  :=  12;
				SET Par_ErrMen  :=  'El Calculo de Interes esta Vacio';
				SET Var_Control :=  'montoAnclar';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- VERIFICAMOS SI HAY ANCLAJES POR AUTORIZAR
		SELECT  IFNULL(COUNT(cede.CedeID),Entero_Cero)
		INTO    Var_Anclajes
			FROM CEDESANCLAJE anc
				INNER JOIN CEDES cede ON anc.CedeAncID  = cede.CedeID
									 AND cede.Estatus   = Est_Act
			WHERE anc.CedeOriID = Par_CedeOriID;

		IF(Var_Anclajes != Entero_Cero) THEN
			IF(Par_Salida = Salida_SI) THEN
				SET Par_NumErr  :=  13;
				SET Par_ErrMen  :=  'Existen Anclajes Pendientes por Autorizar.';
				SET Var_Control :=  'inversionOriID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Var_DiaInhabil = SabDom AND Var_EsHabil = No_DiaHabil) THEN
			SET Par_NumErr  :=  14;
			SET Par_ErrMen  :=  CONCAT('El Tipo de CEDE ', Var_TipCede,' Tiene Parametrizado Dia Inhabil: Sabado y Domingo
								por tal Motivo No se Puede Anclar el CEDE.');
			SET Var_Control :=  'cedeOriID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusCede = Cancelado) THEN
			SET Par_NumErr  :=  15;
			SET Par_ErrMen  :=  'El CEDE ha sido cancelado y no puede ser Modificado';
			SET Var_Control :=  'cedeOriID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_TipoTasa = TasaFija)THEN
			SET Par_TasaBaseID     := Entero_Cero;
			SET Par_SobreTasa      := Decimal_Cero;
			SET Par_PisoTasa       := Decimal_Cero;
			SET Par_TechoTasa      := Decimal_Cero;
		END IF;

		-- DANDO DE ALTA EL ANCLAJE EN LA TABLA DE 'CEDES'
		CALL CEDESALT (
			Var_TipCede,            Var_CuentaAho,      	Var_Cliente,        	VarFechaSistema,        Var_FechaVen,
			Par_MontoTotalAnclar,   Par_Plazo,          	Par_Tasa,           	Par_TasaISR,            Par_TasaNeta,
			Par_InteresGenerado,    Par_InteresRecibir, 	Par_InteresRetener, 	Decimal_Cero,           Par_ValorGat,
			Par_ValorGatReal,       Var_MonedaID,       	Fecha_Vacia,        	Var_TipoPagoInt,        Var_DiasPeriodo,
            Var_PagoIntCal,			Par_CalculoInteres,		Par_TasaBaseID,         Par_SobreTasa,      	Par_PisoTasa,
            Par_TechoTasa,          Entero_Cero,			Var_Reinversion,   	 	Var_Reinvertir,         ContanteDOS,
            Var_CajaRetiro,			Par_Plazo,				Var_CedeAncID, 			Salida_NO,         		Par_NumErr,
            Par_ErrMen,         	Par_EmpresaID,          Aud_Usuario,        	Aud_FechaActual,    	Aud_DireccionIP,
            Aud_ProgramaID,			Aud_Sucursal,   		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero  )THEN
			LEAVE ManejoErrores;
		END IF;

		-- DANDO DE ALTA EL ANCLAJE EN LA TABLA 'CEDESANCLAJE'
		SET Var_CedeAnclajeID := (SELECT IFNULL(MAX(CedeAnclajeID), Entero_Cero) + Entero_Uno FROM CEDESANCLAJE);

		INSERT INTO CEDESANCLAJE(
			CedeAnclajeID,          CedeOriID,              CedeAncID,                  MontoConjunto,              TotalRecibir,
			NuevaTasa,              NuevoInteresGenerado,   NuevoInteresRecibir,        InteresGeneradoOriginal,    InteresRecibirOriginal,
			TasaOriginal,           TasaBaseIDOriginal,     SobreTasaOriginal,          PisoTasaOriginal,           TechoTasaOriginal,
			CalculoIntOriginal,     ValorGatOriginal,       ValorGatRealOriginal,       TasaNetaOriginal,           FechaAnclaje,
			UsuarioAncID,           SucursalAncID,          SaldoProvision,             EmpresaID,                  Usuario,
			FechaActual,            DireccionIP,            ProgramaID,                 Sucursal,                   NumTransaccion)
		VALUES(
			Var_CedeAnclajeID,      Par_CedeOriID,          Var_CedeAncID,              Par_MontoTotal,             Par_TotalRecibir,
			Par_NuevaTasa,          Par_NuevoIntGen,        Par_NuevoIntReci,           Var_IntGeneOri,             Var_IntReciOri,
			Var_TasaOri,            Var_TasaBaseOri,        Var_SobreTasaOri,           Var_PisoTasaOri,            Var_TechoTasaOri,
			Var_CalIntOri,          Var_ValorGatOri,        Var_ValGatRealOri,          Var_TasaNetaOri,            VarFechaSistema,
			Par_UsuarioAncID,       Par_SucursalAncID,      Var_SaldoProv,              Par_EmpresaID,              Aud_Usuario,
			Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,             Aud_Sucursal,               Aud_NumTransaccion);

		SET Par_NumErr  :=  0;
		SET Par_ErrMen  :=  CONCAT('CEDE Agregado Exitosamente: ', CONVERT(Var_CedeAncID, CHAR));
		SET Var_Control :=  'cedeAnclajeID';

	END ManejoErrores;

    IF(Par_Salida = Salida_SI)THEN
        SELECT  Par_NumErr      AS NumErr,
                Par_ErrMen      AS ErrMen,
                Var_Control     AS control,
                Var_CedeAncID   AS consecutivo;
    END IF;

END TerminaStore$$