package tarjetas.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import tarjetas.bean.TCPeriodoLineaBean;

public class TCPeriodoLineaDAO extends BaseDAO{
	
	/*Consulta para la pantalla de Asignacion de tarjeta  */ 
	public TCPeriodoLineaBean infoLineaCredido(final int tipoConsulta, TCPeriodoLineaBean tCPeriodoLineaBean){
		String query = "call TC_PERIODOSLINEACON(?,?,?,   ?,?,?,?,?,?,?);";
		
		Object[] parametros = { 
				tCPeriodoLineaBean.getLineaTarjetaCredID(),
				tCPeriodoLineaBean.getFechaConsulta(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarjetaCreditoDAO.consultaComisionSol",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO 																	
						
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TC_PERIODOSLINEACON(" + Arrays.toString(parametros) +")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TCPeriodoLineaBean tCPeriodoLineaBean = new TCPeriodoLineaBean();				
							
				tCPeriodoLineaBean.setPagoNoGenInteres(resultSet.getString("PagoNoGenInteres"));
				tCPeriodoLineaBean.setPagoMinimo(resultSet.getString("PagoMinimo"));
				tCPeriodoLineaBean.setSaldoCorte(resultSet.getString("SaldoCorte"));
				tCPeriodoLineaBean.setFechaProxCorte(resultSet.getString("FechaProxCorte"));
				tCPeriodoLineaBean.setFechaExigible(resultSet.getString("FechaExigible"));
				tCPeriodoLineaBean.setPagos(resultSet.getString("Pagos"));
				tCPeriodoLineaBean.setCargos(resultSet.getString("Cargos"));
				tCPeriodoLineaBean.setInteres(resultSet.getString("Intereses"));
				tCPeriodoLineaBean.setComisiones(resultSet.getString("Comisiones"));
				tCPeriodoLineaBean.setSaldoFecha(resultSet.getString("SaldoFecha"));
				tCPeriodoLineaBean.setSaldoFavor(resultSet.getString("SaldoFavor"));
				tCPeriodoLineaBean.setMontoDisponible(resultSet.getString("MontoDisponible"));
				tCPeriodoLineaBean.setMontoLinea(resultSet.getString("MontoLinea"));
				
				
				tCPeriodoLineaBean.setFechaExigible(resultSet.getString("FechaExigible"));
				return tCPeriodoLineaBean;
			}
		});
		return matches.size() > 0 ? (TCPeriodoLineaBean) matches.get(0) : null;
	}
	
	public List listaFechaCorte(int tipoLista, TCPeriodoLineaBean tCPeriodoLineaBean){
		String query = "call TC_PERIODOSLINEALIS(?,?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {	
								tCPeriodoLineaBean.getLineaTarjetaCredID(),
								tipoLista,
								
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TC_PERIODOSLINEALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				TCPeriodoLineaBean tCPeriodoLinea = new TCPeriodoLineaBean();
				tCPeriodoLinea.setFechaCorte(resultSet.getString("FechaCorte"));
				return tCPeriodoLinea;
			}
		});
		return matches;
	}
	

}
