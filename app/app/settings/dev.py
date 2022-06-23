from .base import *

# SECURITY WARNING: don't run with debug turned on in production!

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('SECRET_KEY')
# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = bool(int(os.environ.get('DEBUG', 1)))

ALLOWED_HOSTS = []

ALLOWED_HOSTS.extend(
    filter(
        None,
        os.environ.get('ALLOWED_HOSTS', '').split(','),
    )
)


EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'


try:
    from .local import *
except ImportError:
    pass
