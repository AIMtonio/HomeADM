package ventanilla.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
 
import pld.reporte.RepParametrosSegOperControlador;
import credito.bean.CreditosBean;
import credito.dao.CreditosDAO;
import credito.dao.SeguroVidaDAO;
import credito.servicio.CreditosServicio;
import cuentas.bean.BloqueoSaldoBean;
import cuentas.dao.BloqueoSaldoDAO;
import cuentas.servicio.BloqueoSaldoServicio;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.bean.RepPagServBean;
import ventanilla.bean.ReversasOperBean;
import ventanilla.servicio.IngresosOperacionesServicio.Enum_Tra_Ventanilla;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;
import seguridad.servicio.SeguridadRecursosServicio;

public class RepPagoSeviciosDAO extends BaseDAO {
	
	
	
//	::::::::::::::::::::::::::::::::::::::REVERSAS::::::::::::::::::::::::::::::::::::::...

// Lista las operaciones realizadas en caja
public List <RepPagServBean> listaRepPagosServicios(RepPagServBean repPagServBean) {
	List <RepPagServBean> listaCajasMovs = null;	
	try{
		String query = "call PAGOSERVICIOREP(?,?,?,?,?, ?,?,?,?,?,"
										  + "?,?);";
		Object[] parametros = { 							
								repPagServBean.getFechaCargaInicial(),
								repPagServBean.getFechaCargaFinal(),
								repPagServBean.getSucursal(),
								repPagServBean.getServicio(),
								repPagServBean.getOrigenPago(),

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								OperacionesFechas.FEC_VACIA,
								Constantes.STRING_VACIO,
								"PAGOSERVICIOREP",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAGOSERVICIOREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {				
				RepPagServBean repPagServ = new RepPagServBean();
				repPagServ.setSucursalID(resultSet.getString("SucursalID"));
				repPagServ.setNombreSucurs(resultSet.getString("NombreSucurs"));
				repPagServ.setCatalogoServID(resultSet.getString("CatalogoServID"));
				repPagServ.setNombreServicio(resultSet.getString("NombreServicio"));
				repPagServ.setFecha(resultSet.getString("Fecha"));
				repPagServ.setReferencia(resultSet.getString("Referencia"));
				repPagServ.setCajaID(resultSet.getString("CajaID"));
				repPagServ.setMontoServicio(resultSet.getString("MontoServicio"));
				repPagServ.setIvaServicio(resultSet.getString("IvaServicio"));
				repPagServ.setComision(resultSet.getString("Comision"));
				repPagServ.setIvaComision(resultSet.getString("IVAComision"));
				repPagServ.setAplicado(resultSet.getString("Aplicado"));
				repPagServ.setOrigenPago(resultSet.getString("OrigenPago"));				
				return repPagServ;
			}
			
		});
		
		listaCajasMovs = matches;
	}catch(Exception e){
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de Movimientos de Cajas", e);
		 
	}
	return listaCajasMovs;
}


				
//
	
}
