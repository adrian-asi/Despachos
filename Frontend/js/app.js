// Modals Logic

// OV Emitir Modal
function abrirModalEmitir(ov, qty) {
    const modal = document.getElementById('modalEmitir');
    if (modal) {
        document.getElementById('modalOvNum').value = ov;
        document.getElementById('modalCantidad').value = qty;
        document.getElementById('modalCantidad').max = qty;
        document.getElementById('maxDisp').innerText = qty;
        modal.classList.add('active');
    }
}

function cerrarModal() {
    const modal = document.getElementById('modalEmitir');
    if (modal) modal.classList.remove('active');
}

function confirmarEmision() {
    alert('Guía Emitida Exitosamente. \nSe actualizará el estado a Parcial/Completo según cantidad.');
    cerrarModal();
    window.location.href = 'ov_emitidas.html';
}

// Programar Despacho Modal
function abrirModalProgramar(gre) {
    const modal = document.getElementById('modalProgramar');
    if (modal) {
        if (gre) {
            document.getElementById('modalGreNum').value = gre;
        }
        modal.classList.add('active');
    }
}

function cerrarModalProgramar() {
    const modal = document.getElementById('modalProgramar');
    if (modal) modal.classList.remove('active');
}

function confirmarProgramacion() {
    alert('Guía(s) agregadas a Hoja de Ruta existosamente.');
    cerrarModalProgramar();
    window.location.href = 'hojas_ruta.html';
}

const hrSelect = document.getElementById('hrSelect');
const newHrFields = document.getElementById('newHrFields');
if (hrSelect) {
    hrSelect.addEventListener('change', (e) => {
        if (e.target.value === 'new') {
            newHrFields.style.display = 'block';
        } else {
            newHrFields.style.display = 'none';
        }
    });
}

// Cierre Guía Modal
function abrirModalCierreGuia() {
    const modal = document.getElementById('modalCierreGuia');
    if (modal) modal.classList.add('active');
}

function cerrarModalCierreGuia() {
    const modal = document.getElementById('modalCierreGuia');
    if (modal) modal.classList.remove('active');
}

// Select All Checkbox Logics
const selectAll = document.getElementById('selectAll');
if (selectAll) {
    selectAll.addEventListener('change', (e) => {
        const checks = document.querySelectorAll('.row-checkbox');
        checks.forEach(check => check.checked = e.target.checked);
    });
}
