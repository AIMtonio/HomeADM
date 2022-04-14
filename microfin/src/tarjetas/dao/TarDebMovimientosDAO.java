package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import tarjetas.bean.TarDebMovimientosBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class TarDebMovimientosDAO extends BaseDAO{
	public TarDebMovimientosDAO() {
		super();
	}
	 
	public List listaGridMovimientos(int tipoLista,TarDebMovimientosBean tarDebMovimientosBean) {
		String query = "call TARDEBBITACORAMOVSLIS(?,?,?,?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				tarDebMovimientosBean.getTarjetaID(),
				tarDebMovimientosBean.getTipoOperacion(),
				tarDebMovimientosBean.getFechaInicio(),
				tarDebMovimientosBean.getFechaVencimiento(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TarDebMovimientosDAO.listaGridMovimientos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBBITACORAMOVSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarDebMovimientosBean movimientosBean = new TarDebMovimientosBean();
				movimientosBean.setFecha(resultSet.getString("Fecha"));
				movimientosBean.setOperacion(resultSet.getString("Operacion"));
				movimientosBean.setTransaccion(resultSet.getString("NumeroTran"));
				movimientosBean.setMonto(resultSet.getString("MontoOpe"));
				movimientosBean.setTerminalID(resultSet.getString("TerminalID"));
				movimientosBean.setNomUbicacionTer(resultSet.getString("NombreUbicaTer"));
				movimientosBean.setDatosTpoAire(resultSet.getString("DatosTiempoAire"));
				return movimientosBean;
			}
		});
		return matches;
	}
	public List movimientosPorCuenta(TarDebMovimientosBean tarDebMovimientosBean){
		List matches = null;
		try{
			String query = "call ISOTRXEXPORTMOVTARCUENTAREP(?,?,?,?,?,	?,?,?,?,?, ?);";
			Object[] parametros = { 									
					tarDebMovimientosBean.getFechaInicio(),
					tarDebMovimientosBean.getFechaVencimiento(),
					tarDebMovimientosBean.getCuentaAho(),
					tarDebMovimientosBean.getTarjetaDebID(),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,								
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ISOTRXEXPORTMOVTARCUENTAREP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					TarDebMovimientosBean bean=new TarDebMovimientosBean();
					bean.setCuentaAho(String.valueOf(resultSet.getLong("CuentaAhoID")));
					bean.setTarjetaDebID(resultSet.getString("NumeroTarjeta"));	
					bean.setFecha(resultSet.getString("FechaRegistroOPer"));	
					bean.setDescripcionMov(resultSet.getString("Descripcion"));	
					bean.setNaturaleza(resultSet.getString("Naturaleza"));	
					bean.setReferenciaCta(resultSet.getString("RereferenciaCta"));
					bean.setMonto(String.valueOf(resultSet.getDouble("MontoAplicado")));
					bean.setCodAutorizacion(resultSet.getString("CodAutorizacion"));	
					bean.setFechaRegOper(resultSet.getString("FechaTransaccion"));	
					bean.setHoraTransaccion(resultSet.getString("HoraTrasaccion"));	
					
					
					return bean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de ISOTRXEXPORTMOVTARCUENTAREP", e);
		}
		return matches;
	}
}
