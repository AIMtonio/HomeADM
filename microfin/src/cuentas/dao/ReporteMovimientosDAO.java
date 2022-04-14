package cuentas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import bancaEnLinea.beanWS.request.ConsultaSaldoDetalleBERequest;
import cliente.bean.ClienteBean;
import cuentas.bean.CuentasAhoBean;
import cuentas.bean.MonedasBean;
import cuentas.bean.ReporteMovimientosBean;
import cuentas.bean.TiposCuentaBean;

public class ReporteMovimientosDAO extends BaseDAO {
	
	//Variables

	public ReporteMovimientosDAO() {
		super();
	}
	
	public List listaMovimientos(ReporteMovimientosBean reporteMovimientos, int tipoLista){
		String query = "call CUENTASAHOMOVLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	
				reporteMovimientos.getCuentaAhoID(),
				reporteMovimientos.getMes(),
				reporteMovimientos.getAnio(),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ReporteMovimientosDAO.listaMovimientos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOMOVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReporteMovimientosBean reporteMov = new ReporteMovimientosBean();
				reporteMov.setFecha(resultSet.getString(1));
				reporteMov.setNatMovimiento(resultSet.getString(2));
				reporteMov.setDescripcionMov(resultSet.getString(3));
				reporteMov.setCantidadMov(resultSet.getString(4));
				reporteMov.setReferenciaMov(resultSet.getString(5));
				reporteMov.setSaldo(resultSet.getString(6));
				return reporteMov;
			}
		});
		return matches;
	}
	
	public List listaReporteMovimientos(ReporteMovimientosBean reporteMovimientos, int tipoLista){
		String query = "call CUENTASMOVREP(?,?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
				reporteMovimientos.getCuentaAhoID(),
				reporteMovimientos.getMes(),
				reporteMovimientos.getAnio(),
				tipoLista,
					
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ReporteMovimientosDAO.listaReporteMovimientos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASMOVREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReporteMovimientosBean reporteMovimientos = new ReporteMovimientosBean();
				reporteMovimientos.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				reporteMovimientos.setClienteID(Utileria.completaCerosIzquierda(resultSet.getInt(2),ClienteBean.LONGITUD_ID));					
				reporteMovimientos.setNombreCompleto(resultSet.getString(3));
				reporteMovimientos.setTipoCuentaID(Utileria.completaCerosIzquierda(resultSet.getInt(4),TiposCuentaBean.LONGITUD_ID));
				reporteMovimientos.setDescripcionTC(resultSet.getString(5));
				reporteMovimientos.setMonedaID(Utileria.completaCerosIzquierda(resultSet.getInt(6),MonedasBean.LONGITUD_ID));
				reporteMovimientos.setDescripcionMo(resultSet.getString(7));
				reporteMovimientos.setSaldoIniMes(resultSet.getString(8));
				reporteMovimientos.setCargosMes(resultSet.getString(9));
				reporteMovimientos.setAbonosMes(resultSet.getString(10));
				reporteMovimientos.setSaldoIniDia(resultSet.getString(11));
				reporteMovimientos.setCargosDia(resultSet.getString(12));
				reporteMovimientos.setAbonosDia(resultSet.getString(13));
				reporteMovimientos.setSaldo(resultSet.getString(14));
				reporteMovimientos.setSaldoDispon(resultSet.getString(15));
				reporteMovimientos.setSaldoBloq(resultSet.getString(16));
				reporteMovimientos.setSaldoSBC(resultSet.getString(17));
				reporteMovimientos.setFechaSistemaMov(resultSet.getString(18));
				reporteMovimientos.setSaldoProm(resultSet.getString(19));
				reporteMovimientos.setSaldoCargosPend(resultSet.getString("Var_SumPenAct"));
				reporteMovimientos.setGat(resultSet.getString("Gat"));
				reporteMovimientos.setGatReal(resultSet.getString("GatReal"));
				
			
				return reporteMovimientos;	 
			}
		});
		return matches;
	}
/// lista detalle movimiento ws	
	public List ConsultaSaldoDetalleWS(ConsultaSaldoDetalleBERequest reporteMovimientos){
		String query = "call CUENTASAHOMOVLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	
				Utileria.convierteLong(reporteMovimientos.getCuentaAhoID()),
				Utileria.convierteEntero(reporteMovimientos.getMes()),
				Utileria.convierteEntero(reporteMovimientos.getAnio()),
				Utileria.convierteEntero(reporteMovimientos.getTipoLis()),
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ReporteMovimientosDAO.listaMovimientos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOMOVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReporteMovimientosBean reporteMov = new ReporteMovimientosBean();
				reporteMov.setFecha(resultSet.getString(1));
				reporteMov.setNatMovimiento(resultSet.getString(2));
				reporteMov.setDescripcionMov(resultSet.getString(3));
				reporteMov.setCantidadMov(resultSet.getString(4));
				reporteMov.setReferenciaMov(resultSet.getString(5));
				reporteMov.setSaldo(resultSet.getString(6));
				return reporteMov;
			}
		});
		return matches;
	}
	
	/* metodo de lista para obtener los movimientos de la cuenta */
	  public List listaReporteMovExcel(final ReporteMovimientosBean reporteMovimientos, int tipoReporte){	
			List ListaResultado=null;
			
			try{
			String query = "CALL CUENTASAHOMOVCON(?,?,?,?,?, ?,?,?,?,?, ?)";

			Object[] parametros ={ 
					reporteMovimientos.getCuentaAhoID(),
					reporteMovimientos.getMes(),
					reporteMovimientos.getAnio(),
					tipoReporte,																

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO};
			
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CUENTASAHOMOVCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteMovimientosBean reporteMovimientos= new ReporteMovimientosBean();
					
					reporteMovimientos.setFecha(resultSet.getString("Fecha"));
					reporteMovimientos.setNatMovimiento(resultSet.getString("NatMovimiento"));
					reporteMovimientos.setDescripcionMov(resultSet.getString("DescripcionMov"));
					reporteMovimientos.setCantidadMov(resultSet.getString("CantidadMov"));
					reporteMovimientos.setReferenciaMov(resultSet.getString("ReferenciaMov"));
					
					reporteMovimientos.setSaldo(resultSet.getString("Saldo"));
					reporteMovimientos.setNombreCompleto(resultSet.getString("Var_Nombre"));

					
					
					return reporteMovimientos ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Asambleas", e);
			}
			return ListaResultado;
		}// fin lista report 	
}

