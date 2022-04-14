-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQGASTOSUCMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REQGASTOSUCMOVALT`;
DELIMITER $$


CREATE PROCEDURE `REQGASTOSUCMOVALT`(
    Par_DetReqGasID     INT(11),
    Par_NumReqGasID     INT(11),
    Par_TipoGastoID     INT(11),
    Par_Observaciones   VARCHAR(50),
    Par_PartPresupuesto DECIMAL(14,2),

    Par_FolioPresupID   INT(11),
    Par_MontPresupuest  DECIMAL(14,2),
    Par_NoPresupuestado DECIMAL(14,2),
    Par_MontoAutorizado DECIMAL(14,2),
    Par_Estatus         CHAR(1),

    Par_TipoDeposito    CHAR(1),
    Par_NumFactura      VARCHAR(20),
    Par_ProveedorID     INT(11),
    Par_SucursalID      INT(11),
    Par_CentroCostoID   INT(11),

    Par_Salida          CHAR(1),

    INOUT Par_NumErr    INT,
    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(20),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )

TerminaStore: BEGIN


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Decimal_Cero        DECIMAL(14,2);
DECLARE Entero_Cero         INT(1);
DECLARE Var_Autorizado      CHAR(1);
DECLARE SalidaNO            CHAR(1);
DECLARE SalidaSI            CHAR(1);
DECLARE Act_MontoDispon     INT;
DECLARE Act_EstatusReq      INT;
DECLARE Act_Principal       INT;
DECLARE Fecha_Vacia         DATE;
DECLARE Estatus_Pag			char(1);
DECLARE Estatus_Req			CHAR(1);


DECLARE Var_CentroCostoID   INT(11);
DECLARE Var_MontoDisp       DECIMAL(14,2);
DECLARE Var_Disponible      DECIMAL(14,2);
DECLARE Var_MontoAut        DECIMAL(12,2);
DECLARE var_CentroCostos    INT;
DECLARE Var_Control         VARCHAR(100);
DECLARE Var_Usuario         INT(11);
DECLARE Var_FechaReq        DATE;
DECLARE Var_FormaPag        CHAR(1);
DECLARE Var_TipoGasto       CHAR(1);
DECLARE Var_EstatusFact		char(1);
DECLARE Var_NumMovReq		INT(11);
DECLARE Var_NumDetFact		INT(11);

SET Cadena_Vacia            := '';
SET Decimal_Cero            := 0.00;
SET Entero_Cero             := 0;
SET Act_MontoDispon         := 3;
SET Var_Autorizado          := 'A';
SET SalidaSI                := 'S';
SET SalidaNO                := 'N';
SET Act_EstatusReq          := 3;
SET Act_Principal           := 1;
SET Fecha_Vacia             := '1900-01-01';
SET Estatus_Pag				:= 'P'; 
SET Estatus_Req				:= 'R';

ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                        'esto le ocasiona. Ref: SP-REQGASTOSUCMOVALT');
                        SET Var_Control = 'sqlException' ;
            END;


IF(IFNULL(Par_NumReqGasID, Entero_Cero)) = Entero_Cero THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '001' AS NumErr,
             'El Numero de Requisicion  esta vacio.' AS ErrMen,
             'NumReqGasID' AS control,
              Entero_Cero AS consecutivo;
    ELSE
        SET Par_NumErr := 1;
        SET Par_ErrMen := 'El Numero de Requisicion  esta vacio.' ;
    END IF;
    LEAVE TerminaStore;
END IF;



SELECT CentroCostoID INTO var_CentroCostos
	FROM CENTROCOSTOS
	WHERE   CentroCostoID=Par_CentroCostoID;

SET var_CentroCostos :=IFNULL(var_CentroCostos,Entero_Cero );
IF (IFNULL(var_CentroCostos,Entero_Cero) = Entero_Cero )THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '002' AS NumErr,
             CONCAT("El Centro de Costos ",Par_CentroCostoID, " no Existe.") AS ErrMen,
             'NumReqGasID' AS control,
              Entero_Cero AS consecutivo;
    ELSE
        SET Par_NumErr := 2;
        SET Par_ErrMen := CONCAT("El Centro de Costos ",Par_CentroCostoID, " no Existe.") ;
    END IF;
    LEAVE TerminaStore;

END IF;

SELECT Estatus 
INTO Var_EstatusFact
FROM FACTURAPROV
WHERE ProveedorID = Par_ProveedorID
AND NoFactura = Par_NumFactura;

IF (Var_EstatusFact = Estatus_Pag)THEN
	IF(Par_Salida = SalidaSI) THEN
		SELECT '003' AS NumErr,
			 CONCAT("La Factura se encuentra Parcialmente Pagada, No se puede agregar a la requisicion") AS ErrMen,
			 'noFactura' AS control,
			  Entero_Cero AS consecutivo;
	ELSE
		SET Par_NumErr := 3;
		SET	Par_ErrMen := CONCAT("La Factura se encuentra Parcialmente Pagada, No se puede agregar a la requisicion") ;
	END IF;
	LEAVE TerminaStore;
    
ELSE 

	-- se actualiza el valor de la fecha se auditoria
	SET Aud_FechaActual := NOW();

	-- se obtiene el numero consecutivo de REQGASTOSUCURMOV
	SET Par_DetReqGasID := (SELECT IFNULL(MAX(DetReqGasID ),Entero_Cero) + 1 FROM REQGASTOSUCURMOV);

	-- Set Var_CentroCostoID :=(select CentroCostoID from SUCURSALES where SucursalID=Par_SucursalID);

	-- si el valor que se recibe para ese movimiento trae un estatus diferente de  autorizado
	IF(Par_Estatus != Var_Autorizado ) THEN 
		-- llamar a FACTURAPROVACT
		-- Si es req. por factura se actualiza el estatus de la factura a en proceso de requisicion de gasto
		IF(IFNULL(Par_NumFactura, Cadena_Vacia)) != Cadena_Vacia THEN
			CALL FACTURAPROVACT(	
				Par_ProveedorID,	Par_NumFactura,		Cadena_Vacia,		Cadena_Vacia,	
				Cadena_Vacia,		Decimal_Cero,		Act_EstatusReq,		Cadena_Vacia,	
				SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,  	
				Aud_Sucursal,		Aud_NumTransaccion);
		END IF;
	ELSE 
		-- si el valor que se recibe para ese movimiento trae un estatus autorizado
		
		IF(IFNULL(Par_NumFactura, Cadena_Vacia)) != Cadena_Vacia THEN
			CALL FACTURAPROVACT(	
				Par_ProveedorID,	Par_NumFactura,		Cadena_Vacia,		Cadena_Vacia,	
				Cadena_Vacia,		Decimal_Cero,		Act_EstatusReq,		Cadena_Vacia,	
				SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,  	
				Aud_Sucursal,		Aud_NumTransaccion);
		END IF;
		IF (Par_FolioPresupID <> Entero_Cero)THEN
			-- Se obtiene el valor del monto disponible del presupuesto por sucursal requisitado
			SET Var_MontoDisp  :=	(SELECT MontoDispon FROM PRESUCURDET WHERE FolioID = Par_FolioPresupID);
			SET Var_Disponible := IFNULL(Var_MontoDisp,Decimal_Cero) - IFNULL(Par_MontoAutorizado,Decimal_Cero);
			IF( IFNULL(Var_Disponible,Decimal_Cero) <= Decimal_Cero)THEN
				SET Var_MontoAut := IFNULL(Var_MontoDisp,Decimal_Cero) ;
			ELSE 
				SET Var_MontoAut := Par_MontoAutorizado;
			END IF;

			-- se actualiza el saldo disponible del presupuesto por sucursal
			CALL PRESUCURDETACT(	
				Par_FolioPresupID,	Entero_Cero,		Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,
				Var_Disponible,		Cadena_Vacia,		Act_MontoDispon,	SalidaNO,		Par_NumErr,		
				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	
				Aud_ProgramaID,		Aud_Sucursal, 		Aud_NumTransaccion 
			);
		END IF; 
	END IF;
    
    
	SELECT COUNT(NoPartidaID) INTO Var_NumDetFact
    FROM DETALLEFACTPROV
    WHERE	ProveedorID = Par_ProveedorID
    AND		NoFactura	= Par_NumFactura;
    
    
    SELECT COUNT(DetReqGasID) INTO Var_NumMovReq
    FROM REQGASTOSUCURMOV
    WHERE	ProveedorID = Par_ProveedorID
    AND		NoFactura	= Par_NumFactura;
    
    SET Var_NumDetFact := (IFNULL(Var_NumDetFact,Entero_Cero));
    SET Var_NumMovReq  := (IFNULL(Var_NumMovReq,Entero_Cero));
    
    
    IF (Var_NumMovReq = Var_NumDetFact)THEN

		IF (Var_EstatusFact = Estatus_Req)THEN
			IF(Par_Salida = SalidaSI) THEN
				SELECT '004' AS NumErr,
					 CONCAT("La Factura se encuentra En proceso de requisicion") AS ErrMen,
					 'noFactura' AS control,
					  Entero_Cero AS consecutivo;
			ELSE
				SET Par_NumErr := 4;
				SET	Par_ErrMen := CONCAT("La Factura se encuentra En proceso de requisicion") ;
			END IF;
			LEAVE TerminaStore;
		END IF;
	END IF;


INSERT INTO REQGASTOSUCURMOV(
    DetReqGasID,            NumReqGasID,            TipoGastoID,            Observaciones,          CentroCostoID,
    PartPresupuesto,        MontPresupuest,         NoPresupuestado,        MontoAutorizado,        Estatus,
    FolioPresupID,          TipoDeposito,           NoFactura,              ProveedorID,            EmpresaID,
    Usuario,                FechaActual,            DireccionIP,            ProgramaID,             Sucursal,
    NumTransaccion)
VALUES  (
    Par_DetReqGasID,        Par_NumReqGasID,        Par_TipoGastoID,        Par_Observaciones,      Par_CentroCostoID,
    Par_PartPresupuesto,    Par_MontPresupuest,     Par_NoPresupuestado,    Par_MontoAutorizado,    Par_Estatus,
    Par_FolioPresupID,      Par_TipoDeposito,       Par_NumFactura,         Par_ProveedorID,        Par_EmpresaID,
    Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
    Aud_NumTransaccion);

IF(Par_Estatus = Var_Autorizado ) THEN
    CALL REQGASTOSUCMOVACT(
        Par_DetReqGasID,        Par_NumReqGasID,        Par_TipoGastoID,        Par_Observaciones,
        Par_PartPresupuesto,    Par_FolioPresupID,      Par_MontPresupuest,     Par_NoPresupuestado,
        Par_MontoAutorizado,    Par_Estatus,            Par_TipoDeposito,       Entero_Cero,
        Aud_Usuario,            Par_ProveedorID,        Act_Principal,          SalidaNO,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion);


     SELECT   UsuarioID,   FechRequisicion, FormaPago,     TipoGasto
        INTO  Var_Usuario, Var_FechaReq,    Var_FormaPag,  Var_TipoGasto
    FROM REQGASTOSUCUR
    WHERE NumReqGasID = Par_NumReqGasID;

    SET Var_Usuario  := IFNULL(Var_Usuario, Entero_Cero);
    SET Var_FechaReq := IFNULL(Var_FechaReq,Fecha_Vacia);
    SET Var_FormaPag := IFNULL(Var_FormaPag,Cadena_Vacia);
    SET Var_TipoGasto:= IFNULL(Var_TipoGasto,Cadena_Vacia);

    CALL REQGASTOSUCURACT(
        Par_NumReqGasID,        Par_SucursalID,         Var_Usuario,            Var_FechaReq,
        Var_FormaPag,           Entero_Cero,            Par_Estatus,            Var_TipoGasto,
        Act_Principal,          SalidaNO,               Par_NumErr,             Par_ErrMen,
        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);


	END IF;
END IF;


END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT '000' AS NumErr,
        CONCAT("Movimientos Agregados Exitosamente, Requisicion: ", CONVERT(Par_NumReqGasID,CHAR))  AS ErrMen,
        'numReqGasID' AS control,
        Par_NumReqGasID AS consecutivo;
ELSE
    SET Par_NumErr := 0;
    SET Par_ErrMen :=CONCAT("Movimientos Agregados Exitosamente, Requisicion: ", CONVERT(Par_NumReqGasID,CHAR));
END IF;

END TerminaStore$$